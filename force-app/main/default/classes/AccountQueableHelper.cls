public with sharing class AccountQueableHelper implements Queueable {

    Sobject[] contactListQueue;

    public AccountQueableHelper(list<Contact> contactsToUpdate) {     
        contactListQueue = contactsToUpdate;

    }

    public void execute(QueueableContext context) {

        Database.Update(contactListQueue);        
    }
}
