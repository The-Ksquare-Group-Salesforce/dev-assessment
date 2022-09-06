public with sharing class ContactController {
  @AuraEnabled(cacheable=true)
  public static List<Contact> getContact(String searchKey) {
    return [
      SELECT id, Name, email, Phone
      FROM contact
      WHERE Name LIKE :'%' + searchKey + '%'
      ORDER BY Name DESC
    ];
  }
}
