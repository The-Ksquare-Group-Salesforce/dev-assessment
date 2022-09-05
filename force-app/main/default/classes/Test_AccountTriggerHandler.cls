@isTest 
private  class Test_AccountTriggerHandler {
    static testMethod void testSyncAccountUpdate() {
        Account acc = new Account(Name = 'Test Acc');
        insert acc;

        List<Contact> conList = new List<Contact>();
        for(Integer i =0; i<20; i++){
            Contact con = new Contact(FirstName = 'Test Con'+i, LastName='Tester', AccountId=acc.Id);
            conList.add(con);
        }
        insert conList;

        Test.startTest();
        acc.PushToVendor__c = 'Yes';
        update acc;
        Test.stopTest();

        System.assertEquals(20, [SELECT COUNT() FROM Contact WHERE Push_Date__c != null]);
    }

    static testMethod void testAsyncAccountUpdate() {
        Account acc = new Account(Name = 'Test Acc');
        insert acc;

        List<Contact> conList = new List<Contact>();
        for(Integer i =0; i<210; i++){
            Contact con = new Contact(FirstName = 'Test Con'+i, LastName='Tester', AccountId=acc.Id);
            conList.add(con);
        }
        insert conList;

        Test.startTest();
        acc.PushToVendor__c = 'Yes';
        update acc;
        Test.stopTest();

        System.assertEquals(210, [SELECT COUNT() FROM Contact WHERE Push_Date__c != null]);
    }
}