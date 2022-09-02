@isTest
public with sharing class Test_ContactQueueable {
  @isTest
  private static void testQueueable() {
    List<Contact> testContacts = new List<Contact>();

    for (Integer i = 0; i < 300; i++) {
      testContacts.add(new Contact(LastName = 'Test from Queueable'));
    }

    insert testContacts;

    List<Contact> toUpdateContacts = [
      SELECT ID
      FROM Contact
      WHERE LastName = 'Test from Queueable'
    ];
    for (Contact con : toUpdateContacts) {
      con.LastName = 'Updated by Queueable Class';
    }

    Test.startTest();
    System.enqueueJob(new ContactQueueable(toUpdateContacts));
    Test.stopTest();

    List<Contact> updatedContacts = [
      SELECT ID
      FROM Contact
      WHERE LastName = 'Updated by Queueable Class'
    ];
    System.assertEquals(300, updatedContacts.size());
  }
}
