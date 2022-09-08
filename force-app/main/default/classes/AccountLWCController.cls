public with sharing class AccountLWCController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String currentAccount, String searchVal){
        searchVal = '%' + searchVal + '%';
        return [select id, FirstName,LastName,Email,Phone, Account.Name, Title from Contact where Id IN (SELECT ContactId FROM AccountContactRelation WHERE AccountId = :currentAccount) AND Name Like :searchVal WITH SECURITY_ENFORCED ORDER BY Name];
    }  
}