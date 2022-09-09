public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getDirectOrIndirectlyContacts(Id accountId){
        List<Contact> contacts = [SELECT Name, Email, Phone, Title FROM Contact WHERE Id IN 
                                  (SELECT ContactId FROM AccountContactRelation WHERE AccountId=:accountId)
                                 ];
        return contacts;
    }
}