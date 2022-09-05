public with sharing class AccountTriggerHelper {

    public static Set<Id> getContactSet(List<AccountContactRelation> accountsContacts){

        Set<Id> contactsIds = new Set<Id>();

        for (AccountContactRelation accContact : accountsContacts){
            contactsIds.add(accContact.ContactId);
        }

        return contactsIds;
    }

    public static Map<Id, String> getLastAccountByContactsMap(Set<Id> contactsIds, List<AccountContactRelation> accountsContacts, Map<Id,Account> newaccMap){
        
        Map<Id, String> accountsByContactsMap = new Map<Id, String>();

        for (Id contactId : contactsIds){
            AccountContactRelation accContact =  accountsContacts.get(accountsContacts.size() -1);


                if( contactId  == accContact.ContactId){

                    if (newaccMap.containsKey(accContact.AccountId)){                        
                        accountsByContactsMap.put(contactId, newaccMap.get(accContact.AccountId).PushToVendor__c);
                    }
                  
                }
    
        }

        return accountsByContactsMap;

    }

    public static void updateContacts(Map<Id, String> lastAccountByContactsMap) {
        
        List<Contact> contactsToUpdate = [SELECT Id, Push_Date__c FROM Contact WHERE Id IN :lastAccountByContactsMap.keySet()];
        for (Contact contact : contactsToUpdate){
                if(lastAccountByContactsMap.get(contact.Id) == 'Yes'){
                    contact.Push_Date__c = System.now();
                }
                else {
                    contact.Push_Date__c = null;
                }
        }
        if (!contactsToUpdate.isEmpty()){
            update contactsToUpdate;

        }
        
    }
    
    @future
    public static void updateContactsAsync(Map<Id, String> lastAccountByContactsMap) {
        
        List<Contact> contactsToUpdate = [SELECT Id, Push_Date__c FROM Contact WHERE Id IN :lastAccountByContactsMap.keySet()];
        for (Contact contact : contactsToUpdate){
                if(lastAccountByContactsMap.get(contact.Id) == 'Yes'){
                    contact.Push_Date__c = System.now();
                }
                else {
                    contact.Push_Date__c = null;
                }
        }
        if (!contactsToUpdate.isEmpty()){
            update contactsToUpdate;

        }
        
    }
    

}
