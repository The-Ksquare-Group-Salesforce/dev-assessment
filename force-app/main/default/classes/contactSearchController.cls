public with sharing class contactSearchController {

    @AuraEnabled
    public static List<Contact> getAllContacts(Integer limitSize, Integer offset){
        
        List<Contact> contactList = [SELECT Id, Name, Email, Phone, Title
                                     FROM Contact
                                     Order by Name
                                     LIMIT :limitSize
                                     OFFSET :offset
                                     ];
        
        return contactList;
    }

    @AuraEnabled
    public static List<Contact> getSearchContacts(String search){

        String searchText = '%%';
        if(!String.isEmpty(search)) searchText = search + '%';
         
        List<Contact> contactList = [SELECT Id, Name, Email, Phone, Title
                                     FROM Contact
                                     WHERE Name LIKE :searchText
                                     Order by Name 
                                     Limit 10
                                     ];
        return contactList;                     
    }
}
