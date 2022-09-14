public with sharing class AccountController {
    @AuraEnabled(cacheable = true)
    public static List<Contact> getContacts(string searchKey, string accountId, Integer limitSize, Integer offset){
        String key = '%' + searchKey + '%';
        return [SELECT Id, Name, Email, Phone, AccountId, Title, Profile_Picture__c
                FROM Contact 
                WHERE Name Like :key AND AccountId = :accountId
                WITH SECURITY_ENFORCED
                LIMIT :limitSize
                OFFSET :offset];
    }
}
