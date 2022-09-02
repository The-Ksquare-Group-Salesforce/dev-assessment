@isTest
public with sharing class Test_AccountTriggerHandler {
  private static Integer BulkSize = 0;

  private static void makeData(Boolean condition) {
    List<Contact> cons = new List<Contact>();
    Account acc = new Account(Name = 'Test 1');
    insert acc;
    Account acc1 = [SELECT Id FROM Account WHERE Name = 'Test 1' LIMIT 1];

    if (condition) {
      for (integer i = 0; i < BulkSize; i++) {
        cons.add(
          new Contact(
            LastName = 'Test',
            AccountId = acc1.Id,
            Push_Date__c = null
          )
        );
      }
    } else {
      for (integer i = 0; i < BulkSize; i++) {
        cons.add(
          new Contact(
            LastName = 'Test',
            AccountId = acc1.Id,
            Push_Date__c = datetime.now()
          )
        );
      }
    }
    insert cons;
  }

  @IsTest
  static void beforeUpdatewithYes() {
    BulkSize=200;
    Test.startTest();
    makeData(true);
    Account acc1 = [SELECT Id FROM Account WHERE Name = 'Test 1' LIMIT 1];
    acc1.PushtoVendor__c = 'Yes';
    update acc1;
    Test.stopTest();
    List<Contact> con = [SELECT Id FROM Contact WHERE Push_Date__c != NULL];

    System.assertEquals(BulkSize, con.size());
  }

  @IsTest
  static void beforeUpdatewithNo() {
    Test.startTest();
    makeData(false);
    Account acc2 = [SELECT Id FROM Account WHERE Name = 'Test 1' LIMIT 1];
    acc2.PushtoVendor__c = 'No';
    update acc2;
    Test.stopTest();
    List<Contact> con = [SELECT Id FROM Contact WHERE Push_Date__c = NULL];

    System.assertEquals(BulkSize, con.size());
  }

  @isTest
  private static void beforeUpdateBatchable() {
    BulkSize = 1001;
    Test.startTest();
    makeData(true);
    Account acc1 = [SELECT Id FROM Account WHERE Name = 'Test 1' LIMIT 1];
    acc1.PushtoVendor__c = 'Yes';
    update acc1;
    Test.stopTest();
    List<Contact> con = [SELECT Id FROM Contact WHERE Push_Date__c != NULL];

    System.assertEquals(BulkSize, con.size());
  }

  @isTest
  private static void beforeUpdateQueueable() {
    BulkSize = 300;
    Test.startTest();
    makeData(true);
    Account acc1 = [SELECT Id FROM Account WHERE Name = 'Test 1' LIMIT 1];
    acc1.PushtoVendor__c = 'Yes';
    update acc1;
    Test.stopTest();
    List<Contact> con = [SELECT Id FROM Contact WHERE Push_Date__c != NULL];

    System.assertEquals(BulkSize, con.size());
  }
}
