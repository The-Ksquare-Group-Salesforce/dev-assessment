public with sharing class ContactsListController {

    @AuraEnabled(cacheable=true)
    public static List<Contact> returnAllContacts(String currentAccount) {
        
        List<AccountContactRelation> accountsContacts = [SELECT Id, ContactId FROM AccountContactRelation WHERE AccountId = :currentAccount];
        Set<String> contactsList = new Set<String>();

        for (AccountContactRelation accContact : accountsContacts){
            contactsList.add(accContact.ContactId); 
        }

        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact
            WHERE Id IN :contactsList 
            WITH SECURITY_ENFORCED
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(String currentAccount, String searchTerm) {
        // Return all contacts when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return returnAllContacts(currentAccount);
        }
        // Prepare query paramters
        searchTerm = '%' + searchTerm + '%';

        List<AccountContactRelation> accountsContacts = [SELECT Id, ContactId FROM AccountContactRelation WHERE AccountId = :currentAccount];
        Set<String> contactsList = new Set<String>();

        for (AccountContactRelation accContact : accountsContacts){
            contactsList.add(accContact.ContactId); 
        }

        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact
            WHERE Id IN :contactsList AND Name LIKE :searchTerm
            WITH SECURITY_ENFORCED
        ];
    }
}
