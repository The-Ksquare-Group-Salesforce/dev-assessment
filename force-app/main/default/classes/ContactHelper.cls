public with sharing class ContactHelper {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getRelatedContactList(String searchKey, String sortBy, String sortDirection, String accId){
        String query = 'SELECT Id, Name, Title, Email, Phone, Picture__c FROM Contact WHERE AccountId =: accId';

        if( searchKey != null && searchKey!=''){
            String key = '%' + searchKey + '%';
            query = 'SELECT Id, Name, Email, Title, Picture__c, Phone FROM Contact WHERE Name LIKE :key AND AccountId =: accId';
        }

        if( sortBy != '' && sortBy != null){
            query += ' ORDER BY ' +  sortBy + ' ' + sortDirection;
        }
        return Database.query(query);
    }
}