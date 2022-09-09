public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getDirectOrIndirectlyContacts(Id accountId){
        Set<Id> contactIds = new Set<Id>();
        for (AccountContactRelation acr : [SELECT ContactId FROM AccountContactRelation WHERE AccountId=:accountId]){
            contactIds.add(acr.ContactId);   
        }
        List<Contact> contacts = [SELECT Name,Email,Phone,Title FROM Contact WHERE Id IN :contactIds];
        return contacts;
    }
}