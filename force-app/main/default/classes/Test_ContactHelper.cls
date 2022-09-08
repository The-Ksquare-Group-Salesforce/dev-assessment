@isTest
public with sharing class Test_ContactHelper {
    @TestSetup
	static void createTestData() {
        Account acc = new Account(
				Name = 'Test Account'
		);
		insert acc;

        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Title = 'Manager',
            Email = 'test@test.com',
            Phone = '1112223333',
            Contact_Photo__c = 'image.jpg',
            AccountId = acc.Id
        );
        insert con;
    }

    @IsTest
	static void testGetContactListPositive() {
        Account acc = [SELECT Id, Name FROM Account LIMIT 1];
        String searchKey = 'test';
        Test.startTest();
		List<Contact> contactList = ContactHelper.getContactList(acc.Id, searchKey);
		Test.stopTest();
		System.assertEquals(contactList.size(), 1, 'Contact list size should be equal to 1');
    }
}
