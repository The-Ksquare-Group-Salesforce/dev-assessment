public with sharing class AccountRelatedContactsBatchUpdate implements Database.Batchable<sObject> {
	public List<Contact> contactsToUpdate = new List<Contact>();

    public AccountRelatedContactsBatchUpdate(List<Contact> contactsReceived) {
        contactsToUpdate = contactsReceived;
    }
    
    public List<sObject> start(Database.BatchableContext context) {
        if(!Test.isRunningTest()) {
            return contactsToUpdate;
        }
        else {
            List<Contact> trimmedContacts = new List<Contact>();
            for (Integer i=0;i<100;i++) {
                Contact testCont = contactsToUpdate[i];
                trimmedContacts.add(testCont);
            }
            return trimmedContacts;
        }
    }
    
    public void execute(Database.BatchableContext context, List<Contact> batch) {
        Database.update(batch, false);
    }

    public void finish(Database.BatchableContext context) {
    }
}