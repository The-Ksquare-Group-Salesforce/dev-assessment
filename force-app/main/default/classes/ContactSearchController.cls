public with sharing class ContactSearchController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getAccountRelatedContacts(String accountId, String searchKey) {
        String query = 'SELECT Id, Name, Title, Email, Phone FROM Contact WHERE AccountId = :accountId';
        if (String.isNotEmpty(searchKey)) {
            String key = '%' + searchKey + '%';
            query += ' AND Name LIKE :key';
        }
        query += ' WITH SECURITY_ENFORCED';
        return Database.query(query);
    }
}