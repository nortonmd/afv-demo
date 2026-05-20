import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import { createRecord } from 'lightning/uiRecordApi';
import submitCompRequest from '@salesforce/apex/CompRequestController.submitCompRequest';
import searchGuests from '@salesforce/apex/CompRequestController.searchGuests';
import COMP_REQUEST_OBJECT from '@salesforce/schema/Comp_Request__c';
import REQUEST_TYPE_FIELD from '@salesforce/schema/Comp_Request__c.Request_Type__c';

export default class CompRequestForm extends LightningElement {
    @track currentStep = 1;
    @track formData = {
        guestId: '',
        guestName: '',
        requestType: '',
        amount: 0,
        comments: ''
    };
    @track isSubmitting = false;
    @track showWarning = false;
    @track guestSearchTerm = '';
    @track guestOptions = [];
    @track showGuestDropdown = false;
    
    requestTypeOptions = [];
    recordTypeId;

    // Get object info for Comp Request
    @wire(getObjectInfo, { objectApiName: COMP_REQUEST_OBJECT })
    objectInfo({ data, error }) {
        if (data) {
            const rtInfos = data.recordTypeInfos;
            this.recordTypeId = Object.keys(rtInfos).find(
                rtId => rtInfos[rtId].name === 'Master'
            );
        }
    }

    // Get picklist values for Request Type
    @wire(getPicklistValues, {
        recordTypeId: '$recordTypeId',
        fieldApiName: REQUEST_TYPE_FIELD
    })
    requestTypePicklist({ data, error }) {
        if (data) {
            this.requestTypeOptions = data.values.map(option => ({
                label: option.label,
                value: option.value
            }));
        }
    }

    get isStep1() {
        return this.currentStep === 1;
    }

    get isStep2() {
        return this.currentStep === 2;
    }

    get progressValue() {
        return (this.currentStep / 2) * 100;
    }

    get stepIndicator() {
        return `Step ${this.currentStep} of 2`;
    }

    get isNextDisabled() {
        return !this.formData.guestId || 
               !this.formData.requestType || 
               !this.formData.amount || 
               this.formData.amount <= 0;
    }

    get formattedAmount() {
        return this.formData.amount ? 
               new Intl.NumberFormat('en-US', { 
                   style: 'currency', 
                   currency: 'USD' 
               }).format(this.formData.amount) : 
               '$0.00';
    }

    handleGuestSearch(event) {
        const searchTerm = event.target.value;
        this.guestSearchTerm = searchTerm;
        
        if (searchTerm.length >= 2) {
            searchGuests({ searchTerm: searchTerm })
                .then(result => {
                    this.guestOptions = result.map(contact => ({
                        id: contact.Id,
                        name: contact.Name,
                        email: contact.Email || '',
                        phone: contact.Phone || ''
                    }));
                    this.showGuestDropdown = this.guestOptions.length > 0;
                })
                .catch(error => {
                    console.error('Error searching guests:', error);
                });
        } else {
            this.showGuestDropdown = false;
        }
    }

    handleGuestSelect(event) {
        const selectedId = event.currentTarget.dataset.id;
        const selectedGuest = this.guestOptions.find(g => g.id === selectedId);
        
        if (selectedGuest) {
            this.formData.guestId = selectedGuest.id;
            this.formData.guestName = selectedGuest.name;
            this.guestSearchTerm = selectedGuest.name;
            this.showGuestDropdown = false;
        }
    }

    handleRequestTypeChange(event) {
        this.formData.requestType = event.detail.value;
    }

    handleAmountChange(event) {
        this.formData.amount = parseFloat(event.target.value) || 0;
        this.showWarning = this.formData.amount > 5000;
    }

    handleCommentsChange(event) {
        this.formData.comments = event.target.value;
    }

    handleNext() {
        if (!this.isNextDisabled) {
            this.currentStep = 2;
        }
    }

    handleBack() {
        this.currentStep = 1;
    }

    handleSubmit() {
        this.isSubmitting = true;

        // Create the comp request record first
        const fields = {
            Guest__c: this.formData.guestId,
            Request_Type__c: this.formData.requestType,
            Comp_Amount__c: this.formData.amount,
            Comments__c: this.formData.comments,
            Status__c: 'Draft'
        };

        // Use LDS to create the record
        const recordInput = { apiName: 'Comp_Request__c', fields };
        
        createRecord(recordInput)
            .then(record => {
                // Now submit the request through Apex
                return submitCompRequest({ compRequestId: record.id });
            })
            .then(result => {
                this.isSubmitting = false;
                
                if (result.success) {
                    this.showToast('Success!', result.message, 'success');
                    this.resetForm();
                } else {
                    this.showToast('Error', result.message, 'error');
                }
            })
            .catch(error => {
                this.isSubmitting = false;
                this.showToast(
                    'Error',
                    'Failed to submit request: ' + this.getErrorMessage(error),
                    'error'
                );
            });
    }

    resetForm() {
        this.currentStep = 1;
        this.formData = {
            guestId: '',
            guestName: '',
            requestType: '',
            amount: 0,
            comments: ''
        };
        this.guestSearchTerm = '';
        this.showWarning = false;
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    getErrorMessage(error) {
        if (error.body && error.body.message) {
            return error.body.message;
        } else if (error.message) {
            return error.message;
        }
        return 'Unknown error occurred';
    }
}