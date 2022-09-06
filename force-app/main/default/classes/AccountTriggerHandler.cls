public with sharing class AccountTriggerHandler {
    public static void handleRelatedContactsChange(List<Account> accounts, Map<Id,Account> oldAccountsMap) {
        Set<Id> pushToVendorPositiveChangedAccs = new Set<Id>();
        Set<Id> pushToVendorNegativeChangedAccs = new Set<Id>();
        List<Contact> relatedContactsToChange = new List<Contact>();
        Set<Id> relatedContactsToChangePositiveIds = new Set<Id>();
        Set<Id> relatedContactsToChangeNegativeIds = new Set<Id>();
        
        for (Account acc : accounts) {
            if (acc.PushToVendor__c == 'Yes' && (acc.PushToVendor__c != oldAccountsMap.get(acc.Id).PushToVendor__c)) {
                pushToVendorPositiveChangedAccs.add(acc.Id);
            }
            if (acc.PushToVendor__c == 'No' && (acc.PushToVendor__c != oldAccountsMap.get(acc.Id).PushToVendor__c)) {
                pushToVendorNegativeChangedAccs.add(acc.Id);
            }
        }
        
        for (Contact contact : [SELECT Id, Push_Date__c, AccountId FROM Contact WHERE AccountId IN :pushToVendorPositiveChangedAccs WITH SECURITY_ENFORCED]) {
            contact.Push_Date__c = date.today();
            relatedContactsToChange.add(contact);
            relatedContactsToChangePositiveIds.add(contact.Id);
        }
        
        for (Contact contact : [SELECT Id, Push_Date__c, AccountId FROM Contact WHERE AccountId IN :pushToVendorNegativeChangedAccs WITH SECURITY_ENFORCED]) {
            contact.Push_Date__c = null;
            relatedContactsToChange.add(contact);
            relatedContactsToChangeNegativeIds.add(contact.Id);
        }
        
        if (!relatedContactsToChange.isEmpty()) {
            if (relatedContactsToChange.size() <= 200) {
                update relatedContactsToChange;
            }
            else if (relatedContactsToChange.size() > 1000) {
                Database.executeBatch(new AccountRelatedContactsBatchUpdate(relatedContactsToChange), 150);
            }
            else {
                asyncUpdateContact(relatedContactsToChangePositiveIds, relatedContactsToChangeNegativeIds);
            }
        } 
    }
    
    @Future
    public static void asyncUpdateContact(Set<Id> contactIdsToUpdatePositive, Set<Id> contactIdsToUpdateNegative) {
        List<Contact> contactsToUpdatePositive = [SELECT Id FROM Contact WHERE Id IN :contactIdsToUpdatePositive WITH SECURITY_ENFORCED];
        List<Contact> contactsToUpdateNegative = [SELECT Id FROM Contact WHERE Id IN :contactIdsToUpdateNegative WITH SECURITY_ENFORCED];
        List<Contact> totalContactsToUpdate = new List<Contact>();
        
        for (Contact positiveCont: contactsToUpdatePositive) {
            positiveCont.Push_Date__c = date.today();
            totalContactsToUpdate.add(positiveCont);
        }
        for (Contact negativeCont: contactsToUpdateNegative) {
            negativeCont.Push_Date__c = null;
            totalContactsToUpdate.add(negativeCont);
        }
        
        update totalContactsToUpdate;
    }
}