public with sharing class ContactsBatch implements Database.Batchable<sObject>{

    public String query;
    public DateTime incomingDateTime;
    public Set<Id> accountIdsSet = new Set<Id>();
    public List<Contact> contListToUpdate = new List<Contact>();

    public ContactsBatch(Set<Id> accountIds, DateTime myDateTime) {
		accountIdsSet = accountIds;
        incomingDateTime = myDateTime;
        query = 'SELECT Id, Name, Push_Date__c FROM Contact WHERE AccountId IN : accountIdsSet' + (Test.isRunningTest() ? ' LIMIT 200' : ''); 
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Contact> contactList) {
        for (Contact contact : contactList) {
            contact.Push_Date__c = incomingDateTime;
            contListToUpdate.add(contact);
        }
        update contListToUpdate;
    }
    
    public void finish(Database.BatchableContext BC) {
        // Send a success email when contacts are updated?
    }
}