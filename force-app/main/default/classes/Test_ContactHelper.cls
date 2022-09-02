@isTest
public with sharing class Test_ContactHelper {
  @TestSetup
  static void makeData() {
    Account testAcc = new Account(Name = 'Test Account From Contact Helper');
    insert testAcc;
    Account testAcc1 = [
      SELECT Id
      FROM Account
      WHERE Name = 'Test Account From Contact Helper'
    ];
    List<Contact> testContacts = new List<Contact>();
    for (Integer i = 0; i < 200; i++) {
      testContacts.add(new Contact(LastName = 'Test', AccountId = testAcc1.id));
    }
    insert testContacts;
  }
  @isTest
  private static void noSearchTest() {
    Account testAcc = [
      SELECT Id
      FROM Account
      WHERE Name = 'Test Account From Contact Helper'
    ];
    Test.startTest();
    List<Contact> relatedContacts = ContactHelper.getRelatedContactList(
      'Test',
      'Name',
      'ASC',
      testAcc.id
    );
    Test.stopTest();
    system.assertEquals(200, relatedContacts.size());
  }

  @isTest
  private static void withSearchTest() {
    Account testAcc = [
      SELECT Id
      FROM Account
      WHERE Name = 'Test Account From Contact Helper'
    ];
    Test.startTest();
    List<Contact> relatedContacts = ContactHelper.getRelatedContactList(
      null,
      null,
      null,
      testAcc.id
    );
    Test.stopTest();
    system.assertEquals(200, relatedContacts.size());
  }
}
