global with sharing class AccountBatchHelper implements Database.Batchable<Sobject> {

    Sobject[] contactListBatch;
    
    global AccountBatchHelper(list<Contact> contactsToUpdate ) {
        contactListBatch = contactsToUpdate;
    }

    public list<Contact> start (Database.BatchableContext bc){

        return contactListBatch;
    }

    global void execute (Database.BatchableContext bc, List<Contact> scope){
      
        Database.update(contactListBatch);
    }

    global void finish(Database.BatchableContext bc){

    }
}
