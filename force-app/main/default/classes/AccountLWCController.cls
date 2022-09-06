public with sharing class AccountLWCController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String currentAccount, String searchVal){
        //return [Select Id,FirstName,LastName,Email,Phone from Contact where accountId=:currentAccount];
        searchVal = '%' + searchVal + '%';
        return [select id, FirstName,LastName,Email,Phone from Contact where Id IN (SELECT ContactId FROM AccountContactRelation WHERE AccountId = :currentAccount) AND Name Like :searchVal WITH SECURITY_ENFORCED];
    }  
}
