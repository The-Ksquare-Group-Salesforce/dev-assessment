public class UpdateContacts_Batch implements Database.Batchable<sObject> {
    
    public Set<Id> contactIds;
    public DateTime pushDate;
    
    public UpdateContacts_Batch(Set<Id> contactIds, DateTime pushDate) {
        this.contactIds = contactIds;
        this.pushDate = pushDate;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        
       	String query = 'SELECT Id, Push_Date__c FROM Contact WHERE Id IN :contactIds' + (Test.isRunningTest() ? ' LIMIT 150':'');
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Contact> contacts) {
        for(Contact contact : contacts) {        
            contact.Push_Date__c = pushDate;
        }

        Database.SaveResult[] srList = Database.update(contacts, false);

        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            }
            else {
                // Operation failed                
                for (Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }
    }   
    
    public void finish(Database.BatchableContext BC) { }
}