public with sharing class ContactSearchClass {
  @AuraEnabled(cacheable = true)
    public static List<Contact> getContacts(Integer limitSize, Integer offSet, String accountId){
      //if (String.isBlank(contactName)) {
        return [SELECT Id, Name, Email, Phone FROM Contact WHERE AccountId = :accountId LIMIT : limitSize OFFSET : offSet];
    //}
      /*String key = '%' + contactName + '%';
      return [SELECT Id, Name, Email, Phone FROM Contact WHERE Name LIKE : key AND AccountId = :accountId];*/
    }
    public ContactSearchClass() {

    }
    @AuraEnabled(cacheable = true)
    public static List<Contact> getContactsOnSearch(String contactName, string accountId){
      String key = '%' + contactName + '%';
      return [SELECT Id, Name, Email, Phone FROM Contact WHERE Name LIKE : key AND AccountId = :accountId];
    }
}
