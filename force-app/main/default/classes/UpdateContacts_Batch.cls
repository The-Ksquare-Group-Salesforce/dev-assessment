global class UpdateContacts_Batch implements Database.Batchable<sObject> {
    
    global Set<Id> contactIds;
    global DateTime pushDate;
    
    global UpdateContacts_Batch(Set<Id> contactIds, DateTime pushDate) {
        this.contactIds = contactIds;
        this.pushDate = pushDate;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Push_Date__c 
            FROM Contact 
            WHERE Id IN :contactIds 
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> contactList) {
        for(Contact contact : contactList) {        
            contact.Push_Date__c = pushDate; // Update Push_Date__c field
        }
        
        try {
            update contactList;
        } catch(Exception e) {
            System.debug(e);
        }
    }   
    
    global void finish(Database.BatchableContext BC) { }
}