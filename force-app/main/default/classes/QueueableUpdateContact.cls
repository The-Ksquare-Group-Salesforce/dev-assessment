public with sharing class QueueableUpdateContact implements Queueable{
    private Set<Id> accountsIds = new Set<Id>();
    public QueueableUpdateContact(Set<Id> accountsId) {
        this.accountsIds = accountsId;
    }

    public void execute(QueueableContext context) { 
        //UpdateContacts.updateCons(this.accountContactsToUpdate);
        List<Contact> contactsUpdated = new List<Contact>([SELECT Id, Account.PushToVendor__c FROM Contact WHERE AccountId IN:accountsIds]);
        for (Contact con : contactsUpdated) {
            if (con.Account.PushToVendor__c == 'Yes') {  
                con.Push_Date__c = Datetime.now();
            } else if (con.Account.PushToVendor__c == 'No'){
                con.Push_Date__c = null;
            }
            
        }

        update contactsUpdated;
    }
}