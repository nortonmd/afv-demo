import { LightningElement, api, wire } from 'lwc';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';

const COLUMNS = [
    {
        label: 'Activity Number',
        fieldName: 'Name',
        type: 'text'
    },
    {
        label: 'Activity Name',
        fieldName: 'Activity_Name__c',
        type: 'text'
    },
    {
        label: 'Activity Type',
        fieldName: 'Activity_Type__c',
        type: 'text'
    },
    {
        label: 'Date & Time',
        fieldName: 'Activity_Date_Time__c',
        type: 'date',
        typeAttributes: {
            year: 'numeric',
            month: 'short',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        }
    },
    {
        label: 'Duration',
        fieldName: 'Duration_Minutes__c',
        type: 'number',
        typeAttributes: {
            suffix: ' min'
        }
    },
    {
        label: 'Cost',
        fieldName: 'Cost__c',
        type: 'currency'
    },
    {
        label: 'Location',
        fieldName: 'Location__c',
        type: 'text'
    },
    {
        label: 'Rating',
        fieldName: 'Guest_Rating__c',
        type: 'number',
        typeAttributes: {
            minimumFractionDigits: 1,
            maximumFractionDigits: 1
        }
    }
];

export default class CompletedStayActivities extends LightningElement {
    @api recordId;
    
    columns = COLUMNS;
    completedActivities = [];
    error;
    isLoading = true;

    @wire(getRelatedListRecords, {
        parentRecordId: '$recordId',
        relatedListId: 'Stay_Activities__r',
        fields: [
            'Stay_Activity__c.Id',
            'Stay_Activity__c.Name',
            'Stay_Activity__c.Activity_Name__c',
            'Stay_Activity__c.Activity_Type__c',
            'Stay_Activity__c.Activity_Date_Time__c',
            'Stay_Activity__c.Duration_Minutes__c',
            'Stay_Activity__c.Cost__c',
            'Stay_Activity__c.Location__c',
            'Stay_Activity__c.Status__c',
            'Stay_Activity__c.Guest_Rating__c'
        ]
    })
    wiredActivities({ error, data }) {
        this.isLoading = false;
        if (data) {
            // Filter only completed activities and flatten the data structure
            this.completedActivities = data.records
                .filter(record => record.fields.Status__c.value === 'Completed')
                .map(record => {
                    return {
                        Id: record.id,
                        Name: record.fields.Name.value,
                        Activity_Name__c: record.fields.Activity_Name__c.value,
                        Activity_Type__c: record.fields.Activity_Type__c.value,
                        Activity_Date_Time__c: record.fields.Activity_Date_Time__c.value,
                        Duration_Minutes__c: record.fields.Duration_Minutes__c.value,
                        Cost__c: record.fields.Cost__c.value,
                        Location__c: record.fields.Location__c.value,
                        Guest_Rating__c: record.fields.Guest_Rating__c.value
                    };
                });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.completedActivities = [];
        }
    }

    get hasActivities() {
        return this.completedActivities && this.completedActivities.length > 0;
    }

    get activityCount() {
        return this.completedActivities ? this.completedActivities.length : 0;
    }
}