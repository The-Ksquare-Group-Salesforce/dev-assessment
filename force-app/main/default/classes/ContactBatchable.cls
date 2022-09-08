global class ContactBatchable implements Database.Batchable<Sobject>, Database.Stateful{
    
    public List<Contact> contactListToUpdate = new List<Contact>();
    
    global void contactBatchList(List<Contact> contactList){
        this.contactListToUpdate = contactList;
    }
    
    global Database.Querylocator start(Database.BatchableContext bc){
       	return Database.getQueryLocator('SELECT Id, Push_Date__c FROM Contact WHERE Id IN :contactListToUpdate '
                                        + (Test.isRunningTest() ? 'LIMIT 150':''));
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> contacts){

        List<Contact> contactsToUpdate = new List<Contact>();
        for(Contact contact: contacts){
            contact.Push_Date__c = Date.today();
            contactsToUpdate.add(contact);
        }
        update contactsToUpdate;
    }
            
    global void finish(Database.BatchableContext bc){        
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        // send email if needed.
    }
    
    
}