@IsTest
public with sharing class ContactControllerTest {
      
    @IsTest
    static void testgetContacts() {
        Account acc = TestSetupHelper.generateAccountList(1, true)[0];// Generate one Account
        List<Contact> contList = TestSetupHelper.generateContactList(20, acc.Id, true);
        Test.startTest();
        List<Contact> con = ContactController.getContacts(acc.Id, '', 20, 0);
        Test.stopTest();
        System.assertEquals(contList.size(),con.size());
    }
}
