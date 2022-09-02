@isTest
public class AccountTriggerHandlerTest {

    @testSetup
    static void setupData(){
                
        //Data for testing the First Scenario = Account with less than 200 contacts.
        
        Account lowerAccount = new Account();
        lowerAccount.Name = 'Account_Lower_Limit';
        insert lowerAccount;
        
        Contact firstContact = new Contact();
        firstContact.FirstName = 'First';
        firstContact.LastName = 'Contact';
        firstContact.Email = 'First.Contact@test.com';
        firstContact.AccountId = lowerAccount.Id;
        
        Contact secondContact = new Contact();
        secondContact.FirstName = 'Second';
        secondContact.LastName = 'Contact';
        secondContact.Email = 'Second.Contact@test.com';
        secondContact.AccountId = lowerAccount.Id;
        
		insert firstContact;
        insert secondContact; 
        
        //Data for testing the Second Scenario = Account Contacts > 200 and <= 1000.
        
        Account middleAccount = new Account();
        middleAccount.Name = 'Account_Middle_Limit';
        insert middleAccount;
        
        List<Contact> middleContactsList = new List<Contact>();
        
        for (Integer i = 1; i < 500; i++) {
            middleContactsList.add(
                new Contact(
                    FirstName = 'Middle',
                    LastName = 'Contact ' + i ,
                    Email = 'Middle.Contact' + i + '@test.com',
                    AccountId = middleAccount.Id
                )
            );
        }
        
        Insert middleContactsList;
    }
    
    @isTest
    static void lowerLimitPushToVendorYes(){
        
        Account accountLowerLimit = [SELECT Id, PushToVendor__c FROM Account WHERE Name = 'Account_Lower_Limit' LIMIT 1];

        test.startTest();
        
        accountLowerLimit.PushToVendor__c = AccountConstants.PUSH_TO_VENDOR_YES;
        update accountLowerLimit;
        
        Contact firstContact = [SELECT Id, Push_Date__c FROM Contact WHERE Email = 'First.Contact@test.com' LIMIT 1];
        Contact secondContact = [SELECT Id, Push_Date__c FROM Contact WHERE Email = 'Second.Contact@test.com' LIMIT 1];

        system.assertNotEquals(firstContact.Push_Date__c, null);
        system.assertNotEquals(secondContact.Push_Date__c, null);
        system.assertEquals(firstContact.Push_Date__c, secondContact.Push_Date__c);
        
        test.stopTest();
    }
    
    @isTest
    static void lowerLimitPushToVendorNo(){
        
        Account accountLowerLimit = [SELECT Id, PushToVendor__c FROM Account WHERE Name = 'Account_Lower_Limit' LIMIT 1];

        test.startTest();
        
        accountLowerLimit.PushToVendor__c = AccountConstants.PUSH_TO_VENDOR_NO;
        update accountLowerLimit;
        
        Contact firstContact = [SELECT Id, Push_Date__c FROM Contact WHERE Email = 'First.Contact@test.com' LIMIT 1];
        Contact secondContact = [SELECT Id, Push_Date__c FROM Contact WHERE Email = 'Second.Contact@test.com' LIMIT 1];

        system.assertEquals(firstContact.Push_Date__c, null);
        system.assertEquals(secondContact.Push_Date__c, null);
        system.assertEquals(firstContact.Push_Date__c, secondContact.Push_Date__c);
        
        test.stopTest();
    }
    
    @isTest
    static void middleLimitPushToVendorYesBatch(){
        
        Account accountMiddleLimit = [SELECT Id, PushToVendor__c FROM Account WHERE Name = 'Account_Middle_Limit' Limit 1];
        List<String> stringListAccountId = new List<String>();
        stringListAccountId.add(accountMiddleLimit.Id);

        test.startTest();
        
        updateContactsBatchable updateContactsBatch = new updateContactsBatchable(stringListAccountId, DateTime.now());
        Database.executeBatch(updateContactsBatch, 1000);
   
        test.stopTest();   
        
        Contact middleContact = [SELECT Id, Push_Date__c FROM Contact WHERE Account.Name = 'Account_Middle_Limit' LIMIT 1];
        system.assertNotEquals(middleContact.Push_Date__c, null);
        
    }
    
    /*@isTest
    static void middleLimitPushToVendorYes(){
        
        Account accountMiddleLimit = [SELECT Id, PushToVendor__c FROM Account WHERE Name = 'Account_Middle_Limit' Limit 1];
        List<String> stringListAccountId = new List<String>();
        stringListAccountId.add(accountMiddleLimit.Id);

        test.startTest();
        
        updateContactsBatchable updateContactsBatch = new updateContactsBatchable(stringListAccountId, DateTime.now());
        Database.executeBatch(updateContactsBatch, 1000);
   
        test.stopTest();   
        
        Contact middleContact = [SELECT Id, Push_Date__c FROM Contact WHERE Account.Name = 'Account_Middle_Limit' LIMIT 1];
        system.assertNotEquals(middleContact.Push_Date__c, null);
        
    }*/
}