@isTest
private with sharing class Test_AccountController {

    @isTest
    static void getContactsTest(){
        TestDataFactory.initData(1, 50);
        Account acc = [SELECT Id FROM Account Limit 1];
        Test.startTest();
        List<Contact> contacts = AccountController.getContacts('test', acc.Id, 50, 0);
        Test.stopTest();
        system.assertEquals(50, contacts.size());
    }
}
