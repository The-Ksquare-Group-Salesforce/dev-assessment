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
        try {
            update contacts;
        } catch(Exception e) {
            System.debug(e);
        }
    }   
    
    public void finish(Database.BatchableContext BC) { }
}