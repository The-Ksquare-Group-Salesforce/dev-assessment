@isTest
private with sharing class Test_UpdateContactsBatchable {
    @isTest
    static void updateContactsBatchableOverTest() {
        TestDataFactory.initData(2, 20);
        List<Contact> contactList = [SELECT Id, Push_Date__c, Account.PushToVendor__c
                                     FROM Contact 
                                     WHERE Account.PushToVendor__c = 'YES'];
        system.assertNotEquals(System.today(), contactList[0].Push_Date__c);
        UpdateContactsBatchable batch = new UpdateContactsBatchable(contactList);
        Test.startTest();
        Id jobid = Database.executeBatch(batch,150);
        Test.stopTest();
        
        contactList = [SELECT Id, Push_Date__c, Account.PushToVendor__c
                        FROM Contact 
                        WHERE Account.PushToVendor__c = 'YES'];

        System.assertEquals(System.today(), contactList[0].Push_Date__c);
    }
}