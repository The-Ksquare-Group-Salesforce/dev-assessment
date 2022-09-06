public with sharing class AccLWCController {
    @AuraEnabled(cacheable = true)
    public static List<Contact> getContactList(String Acc, String searchStr){

        searchStr = '%'+searchval+'%';

        return [SELECT Id, FirstName, LastName, Email, Phone, Account.Name, Title FROM Contact WHERE Id IN (SELECT Contact Id FROM AccountContactRelation WHERE AccountId = :Acc) AND Name LIKE :searchStr];
    }
}
