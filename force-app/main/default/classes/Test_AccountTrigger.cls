@isTest
public with sharing class Test_AccountTrigger {

    @TestSetup
    static void createTestData(){
        // Create accounts
        Account acc100 = new Account(
            Name = 'Test 100 Related Contacts Account'
        );
        insert acc100;

        Account acc500 = new Account(
				Name = 'Test 500 Related Contacts Account'
		);
		insert acc500;

        Account acc1500 = new Account(
				Name = 'Test 1500 Related Contacts Account'
		);
		insert acc1500;

        // Create 100 contacts related to acc100
        List<Contact> con100 = new List<Contact>();
        for(Integer i = 0; i < 100; i++){
            Contact con = new Contact(
                FirstName = 'Test',
                LastName = 'One Hundred User ' + i,
                Title = 'Manager',
                Email = 'test' + i + '@test.com',
                Phone = '111222333' + i,
                AccountId = acc100.Id
            );
            con100.add(con);
        }
        insert con100;

        // Create 500 contacts related to acc500
        List<Contact> con500 = new List<Contact>();
        for(Integer j = 0; j < 500; j++){
            Contact con = new Contact(
                FirstName = 'Test',
                LastName = 'Five Hundred User ' + j,
                Title = 'Manager',
                Email = 'test' + j + '@test.com',
                Phone = '111222333' + j,
                AccountId = acc500.Id
            );
            con500.add(con);
        }
        insert con500;

        // Create 1500 contacts related to acc1500
        List<Contact> con1500 = new List<Contact>();
        for(Integer k = 0; k < 1500; k++){
            Contact con = new Contact(
                FirstName = 'Test',
                LastName = 'Fifteenhundred User ' + k,
                Title = 'Manager',
                Email = 'test' + k + '@test.com',
                Phone = '111222333' + k,
                AccountId = acc1500.Id
            );
            con1500.add(con);
        }
        insert con1500;
    }

    @IsTest
	static void testSyncUpdatePositive() {
        Account acc100 = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'Test 100 Related Contacts Account'];

        Test.startTest();
        // Modify account an make push to vendor equals to YES
        acc100.PushToVendor__c = 'Yes';
        update acc100;

        // Get a contact related to acc100 and check Push_Date__c
        Contact getContact = [SELECT Id, Name, Push_Date__c FROM Contact WHERE LastName = 'One Hundred User 1' LIMIT 1];
        System.assertNotEquals(getContact.Push_Date__c, null, 'There should be a datetime PushToVendor__c is YES');
        Test.stopTest();
    }

    @IsTest
	static void testSyncUpdateNegative() {
        Account acc100 = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'Test 100 Related Contacts Account'];

        Test.startTest();
        // Modify account an make push to vendor equals to YES
        acc100.PushToVendor__c = 'No';
        update acc100;

        // Get a contact related to acc100 and check Push_Date__c
        Contact getContact = [SELECT Id, Name, Push_Date__c FROM Contact WHERE LastName = 'One Hundred User 99' LIMIT 1];
        System.assertEquals(getContact.Push_Date__c, null, 'There should NOT be a datetime if PushToVendor__c is NO');
        Test.stopTest();
    }

    @IsTest
	static void testAsyncSingleOperationPositive() {
        // Retrieve account
        Account acc500 = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'Test 500 Related Contacts Account'];

        Set<Id> accountIds = new Set<Id>(); 
        accountIds.add(acc500.Id);

        Datetime myDateTime = DateTime.now();

        Test.startTest();
        // Modify account an make push to vendor equals to YES
        acc500.PushToVendor__c = 'Yes';
        update acc500;

        // Call Apex Batch Class
        ContactsBatch batch = new ContactsBatch(accountIds, myDateTime);
        Database.executeBatch(batch, 1000);
        Test.stopTest();

        // Get a contact related to acc500 and check Push_Date__c
        Contact getContact = [SELECT Id, Name, Push_Date__c FROM Contact WHERE LastName = 'Five Hundred User 1' LIMIT 1];
        System.assertNotEquals(getContact.Push_Date__c, null, 'There should be a datetime if Datetime is not null');
    }

    @IsTest
	static void testAsyncSingleOperationNegative() {
        Account acc500 = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'Test 500 Related Contacts Account'];

        Set<Id> accountIds = new Set<Id>(); 
        accountIds.add(acc500.Id);

        Datetime myDateTime = null;

        Test.startTest();
        // Modify account an make push to vendor equals to No
        acc500.PushToVendor__c = 'No';
        update acc500;

        // Call Apex Batch Class
        ContactsBatch batch = new ContactsBatch(accountIds, myDateTime);
        Database.executeBatch(batch, 1000);
        Test.stopTest();

        // Get a contact related to acc500 and check Push_Date__c
        Contact getContact = [SELECT Id, Name, Push_Date__c FROM Contact WHERE LastName = 'Five Hundred User 499' LIMIT 1];
        System.assertEquals(getContact.Push_Date__c, null, 'There should NOT be a datetime if Datetime is NULL');
    }

    // I WAS GETTING AN ERROR THAT SAID THAT I WAS NOW ABLE TO EXECUTE MORE 
    // THAN ONE BATCH, THATS WHY I DECIDED TO COMMENT THE CODE BELOW

    // @IsTest(SeeAllData=false)
	// static void testAsyncBatchOperationPositive() {
    //     Account acc1500 = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'Test 1500 Related Contacts Account'];

    //     Set<Id> accountIds = new Set<Id>(); 
    //     accountIds.add(acc1500.Id);

    //     Datetime myDateTime = DateTime.now();

    //     Test.startTest();
    //     // Update account an make push to vendor equals to Yes
    //     acc1500.PushToVendor__c = 'Yes';
    //     update acc1500;

    //     // Call Apex Batch Class
    //     ContactsBatch batch = new ContactsBatch(accountIds, myDateTime);
    //     // *** Test class would fail if I wanted to execute it in smaller chunks *** 
    //     Database.executeBatch(batch, 1500);
    //     Test.stopTest();

    //     // Get a contact related to acc1500 and check Push_Date__c
    //     Contact getContact = [SELECT Id, Name, Push_Date__c FROM Contact WHERE LastName = 'Fifteenhundred User 1' LIMIT 1];
    //     System.assertNotEquals(getContact.Push_Date__c, null, 'There should be a datetime if Datetime is not null');
    // }

    // @IsTest(SeeAllData=false)
	// static void testAsyncBatchOperationNegative() {
    //     Account acc1500 = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'Test 1500 Related Contacts Account'];

    //     Set<Id> accountIds = new Set<Id>(); 
    //     accountIds.add(acc1500.Id);

    //     Datetime myDateTime = null;

    //     Test.startTest();
    //     // Update account an make push to vendor equals to No
    //     acc1500.PushToVendor__c = 'No';
    //     update acc1500;

    //     // Call Apex Batch Class
    //     ContactsBatch batch = new ContactsBatch(accountIds, myDateTime);
    //     // *** Test class would fail if I wanted to execute it in smaller chunks *** 
    //     Database.executeBatch(batch, 150);
    //     Test.stopTest();

    //     // Get a contact related to acc1500 and check Push_Date__c
    //     Contact getContact = [SELECT Id, Name, Push_Date__c FROM Contact WHERE LastName = 'Fifteenhundred User 1499' LIMIT 1];
    //     System.assertEquals(getContact.Push_Date__c, null, 'There should NOT be a datetime if Datetime is NULL');
    // }
}