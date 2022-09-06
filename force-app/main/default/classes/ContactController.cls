public with sharing class ContactController{
    @AuraEnabled(cacheable = true)
    public static List<Contact> getContacts(String accountId, String filter, Integer rowLimit, Integer rowOffset){
        List<Contact> conList = new List<Contact>();
        // As I type, when the character count is equal to 3 or more the system performs a search and display any contact that begins with the string I typed.
        System.debug(filter);
        if (filter.length() > 2){
            filter = '%' + filter + '%';
            conList = [SELECT Id, Name, AccountId, Email, Phone
                       FROM Contact
                       WHERE Name LIKE:filter AND AccountId = :accountId
                       WITH SECURITY_ENFORCED
                       ORDER BY Name
                       LIMIT :rowLimit
                       OFFSET :rowOffset];
        } else{
            conList = [SELECT Id, Name, AccountId, Email, Phone
                       FROM Contact
                       WHERE  AccountId = :accountId
                       WITH SECURITY_ENFORCED
                       ORDER BY Name
                       LIMIT :rowLimit
                       OFFSET :rowOffset  ];
        }
        return conList;
    }

}