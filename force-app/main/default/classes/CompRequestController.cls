public with sharing class CompRequestController {
    
    private static final Decimal APPROVAL_THRESHOLD = 5000.00;
    
    /**
     * Submit a comp request with automatic approval logic
     * @param compRequestId The ID of the comp request to submit
     * @return Map containing success status and message
     */
    @AuraEnabled
    public static Map<String, Object> submitCompRequest(Id compRequestId) {
        Map<String, Object> result = new Map<String, Object>();
        
        try {
            // Query the comp request with all necessary fields
            Comp_Request__c request = [
                SELECT Id, Name, Comp_Amount__c, Status__c, Guest__c, 
                       Request_Type__c, Comments__c, Requesting_User__c, Manager__c,
                       Flagged_for_Manager_Review__c
                FROM Comp_Request__c 
                WHERE Id = :compRequestId
                LIMIT 1
            ];
            
            // Set requesting user to current user
            request.Requesting_User__c = UserInfo.getUserId();
            request.Submission_Date__c = System.now();
            request.Status__c = 'Submitted';
            
            // Check if amount exceeds threshold
            if (request.Comp_Amount__c > APPROVAL_THRESHOLD) {
                // Flag for manager review
                request.Flagged_for_Manager_Review__c = true;
                request.Status__c = 'Pending Manager Review';
                
                // Get the requesting user's manager
                User requestingUser = [
                    SELECT Id, ManagerId 
                    FROM User 
                    WHERE Id = :request.Requesting_User__c 
                    LIMIT 1
                ];
                
                if (requestingUser.ManagerId != null) {
                    request.Manager__c = requestingUser.ManagerId;
                } else {
                    result.put('success', false);
                    result.put('message', 'Cannot submit request: Your user profile does not have a manager assigned. Please contact your administrator.');
                    return result;
                }
            } else {
                // Auto-approve
                request.Status__c = 'Auto-Approved';
                request.Flagged_for_Manager_Review__c = false;
            }
            
            // Update the comp request
            update request;
            
            // If flagged, create a task for the manager
            if (request.Flagged_for_Manager_Review__c && request.Manager__c != null) {
                createManagerTask(request);
            }
            
            result.put('success', true);
            result.put('status', request.Status__c);
            result.put('flagged', request.Flagged_for_Manager_Review__c);
            
            if (request.Status__c == 'Auto-Approved') {
                result.put('message', 'Your comp request has been automatically approved!');
            } else {
                result.put('message', 'Your comp request has been submitted for manager review.');
            }
            
        } catch (Exception e) {
            result.put('success', false);
            result.put('message', 'Error submitting request: ' + e.getMessage());
        }
        
        return result;
    }
    
    /**
     * Create a task for the manager to review the comp request
     * @param request The comp request that needs manager review
     */
    private static void createManagerTask(Comp_Request__c request) {
        // Get guest name
        String guestName = 'Unknown Guest';
        if (request.Guest__c != null) {
            Contact guest = [SELECT Name FROM Contact WHERE Id = :request.Guest__c LIMIT 1];
            guestName = guest.Name;
        }
        
        // Get requesting user name
        String userName = [SELECT Name FROM User WHERE Id = :request.Requesting_User__c LIMIT 1].Name;
        
        // Create task description with required information
        String taskDescription = String.format(
            'Comp Request Details:\n\n' +
            'Guest Name: {0}\n' +
            'Requesting User: {1}\n' +
            'Request Type: {2}\n' +
            'Amount: ${3}\n' +
            'Comments: {4}',
            new List<String>{
                guestName,
                userName,
                request.Request_Type__c,
                String.valueOf(request.Comp_Amount__c),
                String.isNotBlank(request.Comments__c) ? request.Comments__c : 'None'
            }
        );
        
        Task managerTask = new Task(
            Subject = 'Review Comp Request: ' + request.Name,
            Description = taskDescription,
            WhatId = request.Id,
            OwnerId = request.Manager__c,
            Priority = 'High',
            Status = 'Not Started',
            ActivityDate = Date.today().addDays(2)
        );
        
        insert managerTask;
    }
    
    /**
     * Get guest options for lookup
     * @param searchTerm The search term entered by the user
     * @return List of matching contacts
     */
    @AuraEnabled(cacheable=true)
    public static List<Contact> searchGuests(String searchTerm) {
        String searchPattern = '%' + searchTerm + '%';
        return [
            SELECT Id, Name, Email, Phone 
            FROM Contact 
            WHERE Name LIKE :searchPattern
            ORDER BY Name 
            LIMIT 10
        ];
    }
}