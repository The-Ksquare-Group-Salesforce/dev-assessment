public with sharing class ContactSearchController {

    @AuraEnabled(cacheable=true)
    public static String getContactList(Integer pageSize, Integer pageNumber, String searchTerm, Id accountId){
        String jsonToReturn = '';
         
        //Offset for SOQL
        Integer offset = (pageNumber - 1) * pageSize;
        Integer recordEnd = pageSize * pageNumber;
        
        ContactWrapper contactWrapperInstance =  new ContactWrapper();  
        
        try{
            // TODO : CHANGE THIS TO USE ACCOUNTCONTACTRELATION SOBJECT BEFORE OPENING THE PULL REQUEST******
            // TODO : SORT BY CONTACT NAME
            contactWrapperInstance.contacts = [SELECT Id, Name, Email, Phone, Title, Contact_Image__c FROM Contact WHERE Name LIKE :searchTerm+'%' AND accountId = :accountId WITH SECURITY_ENFORCED LIMIT :pageSize OFFSET :offset];
        }catch(QueryException e){
            System.debug(e.getMessage());
            throw new AuraHandledException('No records');
        }
        
        contactWrapperInstance.pageSize = pageSize;
        contactWrapperInstance.pageNumber = pageNumber;
        contactWrapperInstance.recordStart = offset + 1;
        contactWrapperInstance.totalRecords = contactWrapperInstance.contacts.size();
        contactWrapperInstance.recordEnd = contactWrapperInstance.totalRecords >= recordEnd ? recordEnd : contactWrapperInstance.totalRecords;
      
        jsonToReturn = JSON.serialize(contactWrapperInstance);
        return jsonToReturn;
    }
     
    public class ContactWrapper {
        public Integer pageSize {get;set;}
        public Integer pageNumber {get;set;}
        public Integer totalRecords {get;set;}
        public Integer recordStart {get;set;}
        public Integer recordEnd {get;set;}
        public List<Contact> contacts {get;set;}
    }
}