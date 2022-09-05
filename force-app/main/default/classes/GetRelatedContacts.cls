public with sharing class GetRelatedContacts {

    @AuraEnabled(cacheable = true)   
    public static List<Contact> GetContacts( String accountId) {
        
        List<Contact> contacts;

        
        contacts = [Select Name, Email, Phone from Contact where AccountId = :accountId];

        return contacts;
    }

    public GetRelatedContacts(){

    }

}
