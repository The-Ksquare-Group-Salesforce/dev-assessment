public with sharing class ContactSearchClass {
  @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String accountId){
      return [SELECT Id, Name, Phone, Email FROM Contact WHERE AccountId = :accountId];
    }
    public ContactSearchClass() {

    }
}
