public with sharing class ContactSearchController {
    @AuraEnabled(cacheable=true)
    public static List <Contact> getContactList(string accountId) {
        System.debug(accountId +'account ID');
        List <Contact>  contactList = New List<Contact>();
        contactList = [SELECT Id, Name, Email, Phone 
        FROM Contact 
        WHERE Id 
        IN (SELECT ContactId FROM AccountContactRelation WHERE AccountId =:accountId)];
        System.debug(contactList +'ContactList');
        return  contactList;
    }
}