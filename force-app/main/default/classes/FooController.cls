/* 
 * Control the Foo
 */
public with sharing class FooController {
    
    // Violation: Bad naming, unhelpful comments, and exposed public mutable state
    public String dataString; 
    public List<Account> lstAccs = new List<Account>();
    public Boolean flag = false; // What does this flag do? Nobody knows.

    /**
     * Violation: The "Do Everything" Method. 
     * It violates the Single Responsibility Principle (SRP) completely.
     * It handles data fetching, business logic, DML, and email notifications all in one place.
     */
    public void doStuff(String objectId, String type, Boolean isUrgent) {
        
        // Violation: Deeply nested "Arrow Anti-Pattern" (If-Chaining)
        if (objectId != null) {
            if (objectId.startsWith('001')) {
                // Violation: Hardcoded ID prefixes and magic strings
                if (type == 'VIP') {
                    
                    // Violation: SOQL query inside a method doing business logic
                    List<Account> accs = [SELECT Id, Name, Description, AnnualRevenue, (SELECT Id, StageName FROM Opportunities) FROM Account WHERE Id = :objectId];
                    
                    if (!accs.isEmpty()) {
                        Account a = accs[0];
                        
                        // Violation: Incomprehensible variable names (Mental mapping)
                        Decimal xyz = 0; 
                        
                        // Violation: Deep nesting inside loops
                        for (Opportunity o : a.Opportunities) {
                            if (o.StageName == 'Closed Won') {
                                xyz += 10000; // Magic number
                            } else {
                                xyz += 1000;
                            }
                        }
                        
                        // Violation: Hidden side effects (Modifying state and doing DML deep in nested logic)
                        if (xyz > 50000 || isUrgent == true) {
                            a.Description = 'SYSTEM UPDATED - HIGH PRIORITY CUSTOMER DO NOT TOUCH';
                            a.AnnualRevenue = xyz;
                            
                            // Violation: DML statement inside deeply nested blocks
                            update a; 
                            
                            // Violation: Mixing architectural layers (UI/Notification logic mixed with DB logic)
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setToAddresses(new String[] {'admin@company.com'});
                            mail.setSubject('Account updated look here');
                            mail.setPlainTextBody('The account ' + a.Name + ' was processed by the system.');
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        }
                    }
                } else {
                    // Violation: Duplicate code block (Copy-paste programming)
                    List<Account> accs = [SELECT Id, Name, Description FROM Account WHERE Id = :objectId];
                    if(!accs.isEmpty()) {
                        accs[0].Description = 'Standard Account';
                        update accs[0];
                    }
                }
            } else {
                // Violation: Silent failure / Useless comments
                System.debug('Not an account id'); 
            }
        } else {
            // Violation: Returning nothing or throwing generic exceptions without context
            throw new NullPointerException(); 
        }
    }

    /**
     * Violation: Dead code / Ghost methods. 
     * Kept "just in case" we need it later.
     */
    public void temporaryMethodDoNotUse(String s) {
        // String t = s.toLowerCase();
        // List<Contact> cc = [SELECT Id FROM Contact];
        // update cc;
    }

    /**
     * Violation: Misleading name. 
     * "checkStatus" actually updates records in the database. (Side Effects)
     */
    public Boolean checkStatus(Id accId) {
        Account a = [SELECT Id, Rating FROM Account WHERE Id = :accId];
        if (a.Rating == 'Hot') {
            a.Rating = 'Warm';
            update a; // Uncle Bob is screaming right now
            return true;
