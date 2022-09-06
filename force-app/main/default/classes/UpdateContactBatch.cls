global class UpdateContactBatch implements Database.Batchable<sObject>{
    // List<Contact> contacts;
    global List<Contact> contactsToUpdate;
    global Account accountToUpdate;
    List<Contact> newContacts = new List<Contact>();
    @TestVisible global UpdateContactBatch(List<Contact> contacts, Account account){
        this.contactsToUpdate = contacts;
        this.accountToUpdate = account;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        Set<Id> ids = new Set<Id>(new Map<Id, Contact>(contactsToUpdate).keySet());
        return Database.getQueryLocator([SELECT Id, Push_Date__c
                                         FROM Contact
                                         WHERE Id = :ids
                                         LIMIT 150]);
    }

    @TestVisible global void execute(Database.BatchableContext info, List<Contact> contacts){

        for (Contact c : contacts){
            if (accountToUpdate.Push_To_Vendor__c == 'Yes'){
                c.Push_Date__c = System.today();
                newContacts.add(c);
            } else{
                c.Push_Date__c = Null;
                newContacts.add(c);
            }
        }

        update newContacts;
    }

    global void finish(Database.BatchableContext info){
    }

}