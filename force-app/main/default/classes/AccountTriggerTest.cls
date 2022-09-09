@isTest public class AccountTriggerTest {
    @testSetup static void setup() {
        List<Account> accList = new List<Account>();
        // Account with contacts count <= 200
       	accList.add(new Account(Name = 'Test account #1'));
        // Account with contacts count > 200 and count <= 1000
        accList.add(new Account(Name = 'Test account #2'));
        // Account with contacts count > 1000
        accList.add(new Account(Name = 'Test account #3'));
        insert accList;
        
        // Insert 170 contacts for account #1
        List<Contact> contactList1 = new List<Contact>();
        for (Integer i = 0; i < 170; i++) {
            contactList1.add(new Contact(
                LastName = 'Test contact #' + i, 
                AccountId = accList[0].Id
            ));
        }
        insert contactList1;
        
        // Insert 600 contacts for account #2
        List<Contact> contactList2 = new List<Contact>();
        for (Integer i = 0; i < 600; i++) {
            contactList2.add(new Contact(
                LastName = 'Test contact #' + i, 
                AccountId = accList[1].Id
            ));
        }
        insert contactList2;
        
        // Insert 1500 contacts for account #3
        List<Contact> contactList3 = new List<Contact>();
        for (Integer i = 0; i < 1500; i++) {
            contactList3.add(new Contact(
                LastName = 'Test contact #' + i, 
                AccountId = accList[2].Id
            ));
        }
        insert contactList3;
    }
    
    @isTest static void testContactUpdateWhenCountLessThanOrEqualTo200() {
        Account acc = [SELECT Id, LastModifiedDate FROM Account WHERE Name = 'Test account #1' LIMIT 1];
        acc.PushToVendor__c = 'Yes';
        Test.startTest();
        	update acc;
        Test.stopTest();
        List<Contact> contacts = [SELECT Id, LastName, Push_Date__c FROM Contact WHERE AccountId=:acc.Id];
        System.assertNotEquals(null, contacts[0].Push_Date__c, 'Contacts Push_Date__c field value should not be null');
    }
    
    @isTest static void testContactUpdateWhenCountLessThanOrEqualTo200AndPTVEqualsNo() {
        Account acc = [SELECT Id, LastModifiedDate FROM Account WHERE Name = 'Test account #1' LIMIT 1];
        acc.PushToVendor__c = 'No';
        Test.startTest();
        	update acc;
        Test.stopTest();
        List<Contact> contacts = [SELECT Id, LastName, Push_Date__c FROM Contact WHERE AccountId=:acc.Id];
        System.assertEquals(null, contacts[0].Push_Date__c, 'Contacts Push_Date__c field value should not be null');
    }
    
    @isTest static void testContactUpdateWhenCountGreaterThan200AndLessThan1000() {
        
        Account acc = [SELECT Id, LastModifiedDate FROM Account WHERE Name = 'Test account #2' LIMIT 1];
        acc.PushToVendor__c = 'Yes';
        Test.startTest();
        	update acc;
        Test.stopTest();
        List<Contact> contacts = [SELECT Id, Push_Date__c FROM Contact WHERE AccountId=:acc.Id];
        System.assertNotEquals(null, contacts[0].Push_Date__c, 'Contacts Push_Date__c field value should not be null');
    }
    
    @isTest static void testContactUpdateWhenCountGreaterThan1000() {
        
        Account acc = [SELECT Id, LastModifiedDate FROM Account WHERE Name = 'Test account #3' LIMIT 1];
        acc.PushToVendor__c = 'Yes';
        Test.startTest();
        	update acc;
        Test.stopTest();
        List<Contact> contacts = [SELECT Id, LastName, Push_Date__c FROM Contact WHERE AccountId=:acc.Id];
        System.assertNotEquals(null, contacts[0].Push_Date__c, 'Contacts Push_Date__c field value should not be null');
    }
}