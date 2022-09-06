@IsTest
public with sharing class AccountTriggerHandlerTest {
	@TestSetup
    static void setup() {
        List<Account> testAccounts = new List<Account>();
        List<Contact> testContacts = new List<Contact>();
        
        for (Integer i=0; i<3; i++) {
            Account testAcc = new Account(Name = 'Test ' + i);
            testAccounts.add(testAcc);
        }
        
        for (Integer i=0; i<3; i++) {
            Account testAccYes = new Account(Name = 'Test Yes ' + i, PushToVendor__c = 'Yes');
            testAccounts.add(testAccYes);
        }
        
        insert testAccounts;
        
        Account accBelow200 = [SELECT Id, Name FROM Account WHERE Name = 'Test 0'];
        for (Integer i=0; i<150; i++) {
            Contact testCont = new Contact(LastName = 'Test ' + i, AccountId = accBelow200.Id);
            testContacts.add(testCont);
        }
        
        Account accBetween200And1000 = [SELECT Id, Name FROM Account WHERE Name = 'Test 1'];
        for (Integer i=0; i<500; i++) {
            Contact testCont = new Contact(LastName = 'Test ' + i, AccountId = accBetween200And1000.Id);
            testContacts.add(testCont);
        }
        
        Account accAbove1000 = [SELECT Id, Name FROM Account WHERE Name = 'Test 2'];
        for (Integer i=0; i<1500; i++) {
            Contact testCont = new Contact(LastName = 'Test ' + i, AccountId = accAbove1000.Id);
            testContacts.add(testCont);
        }
        
        Account accBelow200Yes = [SELECT Id, Name FROM Account WHERE Name = 'Test Yes 0'];
        for (Integer i=0; i<150; i++) {
            Contact testCont = new Contact(LastName = 'Test ' + i, AccountId = accBelow200Yes.Id);
            testContacts.add(testCont);
        }
        
        Account accBetween200And1000Yes = [SELECT Id, Name FROM Account WHERE Name = 'Test Yes 1'];
        for (Integer i=0; i<500; i++) {
            Contact testCont = new Contact(LastName = 'Test ' + i, AccountId = accBetween200And1000Yes.Id);
            testContacts.add(testCont);
        }
        
        Account accAbove1000Yes = [SELECT Id, Name FROM Account WHERE Name = 'Test Yes 2'];
        for (Integer i=0; i<1500; i++) {
            Contact testCont = new Contact(LastName = 'Test ' + i, AccountId = accAbove1000Yes.Id);
            testContacts.add(testCont);
        }
        
        insert testContacts;
    }
    
    @IsTest
    static void testUpdateBelow200Contacts_YesCase() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test 0'];
        List<Contact> testContacts = [SELECT Id, Name, AccountId, Push_Date__c FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(150, testContacts.size());
        System.assertEquals(null, testContacts[0].Push_Date__c);
        
        Test.startTest();
        	testAccount.PushToVendor__c = 'Yes';
        	update testAccount;
        Test.stopTest();
        
        Contact testContactChanged = [SELECT Id, Name, AccountId, Push_Date__c FROM Contact WHERE AccountId = :testAccount.Id LIMIT 1];
        System.assertEquals(date.today(), testContactChanged.Push_Date__c);
    }
    
    @IsTest
    static void testUpdateBetween200and1000Contacts_YesCase() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test 1'];
        List<Contact> testContacts = [SELECT Id, Name, AccountId, Push_Date__c FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(500, testContacts.size());
        System.assertEquals(null, testContacts[0].Push_Date__c);
        
        Test.startTest();
        	testAccount.PushToVendor__c = 'Yes';
        	update testAccount;
        Test.stopTest();
        
        Contact testContactChanged = [SELECT Id, Name, AccountId, Push_Date__c FROM Contact WHERE AccountId = :testAccount.Id LIMIT 1];
        System.assertEquals(date.today(), testContactChanged.Push_Date__c);
    }
    
    @IsTest
    static void testUpdateAbove1000Contacts_YesCase() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test 2'];
        List<Contact> testContacts = [SELECT Id, Name, AccountId, Push_Date__c FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(1500, testContacts.size());
        System.assertEquals(null, testContacts[0].Push_Date__c);
        
        Test.startTest();
        	testAccount.PushToVendor__c = 'Yes';
        	update testAccount;
        	Database.executeBatch(new AccountRelatedContactsBatchUpdate(testContacts), 150);
        Test.stopTest();
        
        Contact testContactChanged = [SELECT Id, Name, AccountId, Push_Date__c FROM Contact WHERE AccountId = :testAccount.Id LIMIT 1];
        System.assertEquals(date.today(), testContactChanged.Push_Date__c);
    }
    
    @IsTest
    static void testUpdateBelow200Contacts_NoCase() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test Yes 0'];
        List<Contact> testContacts = [SELECT Id, Name, AccountId, Push_Date__c FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(150, testContacts.size());
        
        Test.startTest();
        	testAccount.PushToVendor__c = 'No';
        	update testAccount;
        Test.stopTest();
        
        Contact testContactChanged = [SELECT Id, Name, AccountId, Push_Date__c FROM Contact WHERE AccountId = :testAccount.Id LIMIT 1];
        System.assertEquals(null, testContactChanged.Push_Date__c);
    }
    
    @IsTest
    static void testUpdateBetween200and1000Contacts_NoCase() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test Yes 1'];
        List<Contact> testContacts = [SELECT Id, Name, AccountId, Push_Date__c FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(500, testContacts.size());   
        
        Test.startTest();
        	testAccount.PushToVendor__c = 'No';
        	update testAccount;
        Test.stopTest();
        
        Contact testContactChanged = [SELECT Id, Name, AccountId, Push_Date__c FROM Contact WHERE AccountId = :testAccount.Id LIMIT 1];
        System.assertEquals(null, testContactChanged.Push_Date__c);
    }
    
    @IsTest
    static void testUpdateAbove1000Contacts_NoCase() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test Yes 2'];
        List<Contact> testContacts = [SELECT Id, Name, AccountId, Push_Date__c FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(1500, testContacts.size());   
        
        Test.startTest();
        	testAccount.PushToVendor__c = 'No';
        	update testAccount;
        Test.stopTest();
        
        Contact testContactChanged = [SELECT Id, Name, AccountId, Push_Date__c FROM Contact WHERE AccountId = :testAccount.Id LIMIT 1];
        System.assertEquals(null, testContactChanged.Push_Date__c);
    }
}