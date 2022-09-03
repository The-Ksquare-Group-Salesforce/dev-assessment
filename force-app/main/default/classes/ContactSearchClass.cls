public with sharing class ContactSearchClass {
  @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String contactName, string accountId){
      if (String.isBlank(contactName)) {
        return [SELECT Id, Name, Email, Phone FROM Contact WHERE AccountId = :accountId];
    }
      String key = '%' + contactName + '%';
      return [SELECT Id, Name, Email, Phone FROM Contact WHERE Name LIKE : key AND AccountId = :accountId];
    }
    public ContactSearchClass() {

    }
}
