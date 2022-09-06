@IsTest
public with sharing class ContactSearchControllerTest {
    @TestSetup
    static void setup() {
        List<Contact> testContacts = new List<Contact>();
        
        Account testAcc = new Account(Name = 'Test Account');
        insert testAcc;
        
        for (Integer i=0; i<10; i++) {
            Contact testCont = new Contact(LastName = 'Test ' + i, AccountId = testAcc.Id);
            testContacts.add(testCont);
        }
        
        insert testContacts;
    }

    @IsTest
    static void testGetAccountRelatedContacts_emptySearchKeyCase() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test Account'];
        String searchKey;
        Test.startTest();
            List<Contact> contactsRetrieved = ContactSearchController.getAccountRelatedContacts(testAccount.Id, searchKey);
        Test.stopTest();

        System.assertEquals(10, contactsRetrieved.size());
    }
    
    @IsTest
    static void testGetAccountRelatedContacts_searchKeyWithValueCase() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test Account'];
        String searchKey = 'Test 1';
        Test.startTest();
            List<Contact> contactsRetrieved = ContactSearchController.getAccountRelatedContacts(testAccount.Id, searchKey);
        Test.stopTest();

        System.assertEquals(1, contactsRetrieved.size());
    }
}