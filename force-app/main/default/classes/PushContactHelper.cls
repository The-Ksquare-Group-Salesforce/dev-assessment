public inherited sharing class PushContactHelper {
    public static void updateContacts(List<Contact> contacts){
        List<Contact> toUpdate= new List<Contact>();
        for (Contact c : contacts){
            if(c.Account.PushToVendor__c == Constants.ACCOUNT_PUSH_TO_VENDOR_YES){
                c.Push_Date__c = Datetime.now();
                toUpdate.add(c);
            }
            else if(c.Account.PushToVendor__c == Constants.ACCOUNT_PUSH_TO_VENDOR_NO){
                c.Push_Date__c = null;
                toUpdate.add(c);
            }
        }
        if(!toUpdate.isEmpty())
        	update contacts;
    }
    public static void updateContacts(List<Account> accounts){
        List<Contact> contacts = [Select Id,Account.PushToVendor__c From Contact Where AccountId In :accounts];
        updateContacts(contacts);
    }
    @future
    public static void updateContactsFuture(List<Id> accountsId){
        updateContacts([Select Id From Account Where Id In :accountsId]);
    }
}