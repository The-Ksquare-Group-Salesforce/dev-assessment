public with sharing class AccountTriggerServices {

    public static List<Contact> updatedContactRelatedOnAfterTrigger(Map<Id, Account> newAccountList, Map<Id, Account> oldAccountList){
        
        Set<Id> accountFilterSet = getFilterAccount(newAccountList, oldAccountList);
        List<Contact> contactList = getAllContacts(accountFilterSet);
        Map<Id, Contact> getContactList = getContactToUpdate(contactList);  
        
	    if(contactList.size()<=200){
            update getContactList.values();
        }else if(contactList.size() > 200 && contactList.size() <=1000){
           Set<Id> contactIds = getContactList.keySet();
           updateContactFuture(contactIds);
        }else{
           ContactBatchable contactJob2 = new ContactBatchable();
           contactJob2.contactBatchList(contactList);
           database.executeBatch(contactJob2, 150);
        }
        return contactList;         
    }
    
    @future
    public static void updateContactFuture(Set<Id> contactIds){  
        
         List<Contact> contactList = [SELECT Id, Push_Date__c, Account.PushToVendor__c FROM Contact WHERE Id IN: contactIds];
         List<Contact> updateContacts = new List<Contact>();
        
         for(Contact contact: contactList){
                contact.Push_Date__c = null;
             if(contact.Account.PushToVendor__c == 'Yes'){
                contact.Push_Date__c = Date.today();
             }
             updateContacts.add(contact);
         }
        
        update updateContacts;
    }
    
    @testVisible
    private static Map<Id, Contact> getContactToUpdate(List<Contact> contactList){
        
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        for(Contact contact: contactList){
            contact.Push_Date__c = null;
            if(contact.Account.PushToVendor__c == 'Yes'){
                contact.Push_Date__c = Date.today();
            }
            contactMap.put(contact.Id, contact);
        }

        return contactMap;
    }
        
    @testVisible
    private static Set<Id> getFilterAccount(Map<Id, Account> newAccountList, Map<Id, Account> oldAccountList){
        
        Set<Id> accountSet = new Set<Id>();
        // filter the account where pushToVendor__c field has been updated.
        for(Id accountId: newAccountList.keySet()){
            if(newAccountList.get(accountId).PushToVendor__c != oldAccountList.get(accountId).PushToVendor__c){
                accountSet.add(accountId);
            }
        }
        return accountSet;
    }
    
    @testVisible
    private static List<Contact> getAllContacts(Set<Id> accountIdsSet){
        
        List<Contact> contactList = [SELECT Id, AccountId, Account.PushToVendor__c, Push_Date__c 
                                     FROM Contact
                                     WHERE AccountId IN :accountIdsSet];
        
        return contactList;
    }
      
}