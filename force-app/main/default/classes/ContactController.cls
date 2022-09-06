public with sharing class ContactController {


    @AuraEnabled(cacheable=true scope='global')
    public static List<Contact> getContactsByAccountId(String accountId){
        return [SELECT Id, FirstName, LastName, Email, Phone, Title FROM Contact WHERE AccountId =: accountId];
    }


    
    @AuraEnabled(cacheable=true scope='global')
    public static List<Contact> getContactsByAccount(String searchTerm,String accountId){
        if (searchTerm == '') {
            return getContactsByAccountId(accountId);
        }
        else {
            searchTerm = '%' + searchTerm + '%';
        // Execute search query
        return [
            SELECT
                Id,
                FirstName,
                LastName,
                Email,
                Phone,
                Title
            FROM Contact
            WHERE (LastName LIKE :searchTerm
            AND AccountId =: accountId)
            OR (FirstName LIKE : searchTerm
            AND AccountId =: accountId)
            WITH SECURITY_ENFORCED
            ORDER BY LastName
            LIMIT 50
        ];
        }
    }
}
