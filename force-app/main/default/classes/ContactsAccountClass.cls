public with sharing class ContactsAccountClass {
    
    
    public ContactsAccountClass() {
              
    }



    @AuraEnabled (cacheable = true)
    public static List<Contact> importContacts(String id){

        List<Contact> dataList = new List<Contact>();
        dataList = [Select Name, Email, Profile_Picture__c, Phone, Title from Contact Where AccountId = :id]; 

        return dataList;        
    }

}
