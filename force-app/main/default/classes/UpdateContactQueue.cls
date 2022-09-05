public with sharing class UpdateContactQueue implements Queueable{
    Account accountToUpdate;
    List<Contact> contactsToUpdate;
    List<Contact> newContacts = new List<Contact>();
    public UpdateContactQueue(List<Contact> contacts, Account account) {
        this.accountToUpdate = account;
        this.contactsToUpdate = contacts;
    }

    public void execute(QueueableContext context){
        for (Contact c : contactsToUpdate){
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
}
