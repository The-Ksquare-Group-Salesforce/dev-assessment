public with sharing class ContactHelper {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(Id recordId, String searchKey) {
        return [SELECT Id, Name, Email, Phone, AccountId, Title, Contact_Photo__c
            FROM Contact WHERE Id IN (SELECT ContactId FROM AccountContactRelation WHERE
            AccountId =: recordId) AND Name LIKE : '%' + searchKey + '%' ORDER BY Name ASC];
    }
}