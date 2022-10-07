public with sharing class AccountTriggerHandler extends TriggerHandler {
    private List<Account> newAccList;
    private Map<Id,Account> oldAccMap;
 
    
    public AccountTriggerHandler() {
        this.newAccList = (List<Account>) Trigger.new;
        this.oldAccMap = (Map<Id, Account>) Trigger.oldMap;
        this.setMaxLoopCount(1);
    }

    public override void afterUpdate(){
        Set<Id> accountsFiltered = checkPushToVendorField(this.newAccList, this.oldAccMap);
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account> accountContactsToUpdate = new List<Account>();
        
        for(Account acc: [SELECT Id, PushToVendor__c, (SELECT Id FROM Contacts) FROM Account WHERE Id in: accountsFiltered]){
            List<Contact> contactsToAdd = new List<Contact>();
            for (Contact con : acc.Contacts) {
                contactsToUpdate.add(con);
                contactsToAdd.add(con);
            }
            if(contactsToAdd.size() > 0){
                accountContactsToUpdate.add(acc);
            }
        }

        if (contactsToUpdate.size() > 0) {
            updateContacts(contactsToUpdate,accountContactsToUpdate,accountsFiltered);
        }

    }

    public static Set<Id> checkPushToVendorField (List<Account> newAccList, Map<Id,Account> oldAccMap){
        
        Set<Id> accountsFiltered = new Set<Id>();

        for (Account acc : newAccList) {
            if (oldAccMap.get(acc.Id).PushToVendor__c != acc.PushToVendor__c){
                accountsFiltered.add(acc.Id);
            }
        }

        return accountsFiltered;
    }

    public static void updateContacts(List<Contact> contacts, List<Account> accounts, Set<Id> accountsFiltered){
        if(contacts.size() <= 200){
            UpdateContacts.updateCons(accounts);
        } else if (contacts.size() > 200 && contacts.size() <= 1000) {
            System.enqueueJob(new QueueableUpdateContact (accountsFiltered));
        } else if (contacts.size() > 1000) {
            Database.executeBatch(new BatchableUpdateContact(accountsFiltered),150);
        }
    }


}