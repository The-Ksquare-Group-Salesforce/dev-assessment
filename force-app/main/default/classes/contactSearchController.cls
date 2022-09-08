public with sharing class contactSearchController {

    @AuraEnabled
    public static List<Contact> getAllContacts(Integer limitSize){
        
        List<Contact> contactList = [SELECT Id, Name, Email, Phone, Title, OrgUrl__c
                                     FROM Contact
                                     Order by Name
                                     LIMIT :limitSize
                                     ];
        
        return contactList;
    }

    @AuraEnabled
    public static List<Contact> getSearchContacts(String search){

        String searchText = '%%';
        if(!String.isEmpty(search)) searchText = search + '%';
         
        List<Contact> contactList = [SELECT Id, Name, Email, Phone, Title, OrgUrl__c
                                     FROM Contact
                                     WHERE Name LIKE :searchText
                                     Order by Name 
                                     ];
        return contactList;                     
    }
}
