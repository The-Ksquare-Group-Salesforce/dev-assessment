@IsTest
public with sharing class AccountTriggerTest{
    
    static testMethod void testUpdateAccountPositiveLessThan200(){
        // Test data setup
        Account acc = TestSetupHelper.generateAccountList(1, true)[0];// Generate one Account
        List<Contact> contList = TestSetupHelper.generateContactList(199, acc.Id, true);
        System.debug('Account Created: ' + acc.Name);
        System.debug('Contacts Created: ' + contList.size());
        // Actual test
        Test.startTest();
        acc.Push_To_Vendor__c = 'Yes';
        update acc;
        Test.stopTest();
        System.assertEquals(199, contList.size());
        List<Contact> contacts = [SELECT Id, Push_Date__c
                                  FROM Contact
                                  WHERE AccountId = :acc.Id];
        for (Contact c : contacts){
            System.assertNotEquals(null, c.Push_Date__c);
        }
    }

    static testMethod void testUpdateAccountNegative200(){
        // Test data setup
        Account acc = TestSetupHelper.generateAccountList(1, true)[0];// Generate one Account
        List<Contact> contList = TestSetupHelper.generateContactList(199, acc.Id, true);
        System.debug('Account Created: ' + acc.Name);
        System.debug('Contacts Created: ' + contList.size());
        // Actual test
        Test.startTest();
        acc.Push_To_Vendor__c = 'No';
        update acc;
        Test.stopTest();
        System.assertEquals(199, contList.size());
        List<Contact> contacts = [SELECT Id, Push_Date__c
                                  FROM Contact
                                  WHERE AccountId = :acc.Id];
        for (Contact c : contacts){
            System.assertEquals(null, c.Push_Date__c);
        }
    }

    static testMethod void testUpdateAccountPositiveMore200LessThan1000(){
        // Test data setup
        Account acc = TestSetupHelper.generateAccountList(1, true)[0];// Generate one Account
        List<Contact> contList = TestSetupHelper.generateContactList(150, acc.Id, true);
        System.debug('Account Created: ' + acc.Name);
        System.debug('Contacts Created: ' + contList.size());
        // Actual test
        Test.startTest();
        acc.Push_To_Vendor__c = 'Yes';
        UpdateContactQueue updatequeue = new UpdateContactQueue(contList,acc);
        Id queue = System.enqueueJob(updatequeue);
        //update acc;
        Test.stopTest();
        System.assertEquals(150, contList.size());
        List<Contact> contacts = [SELECT Id, Push_Date__c
                                  FROM Contact
                                  WHERE AccountId = :acc.Id];
        for (Contact c : contacts){
            System.assertNotEquals(null, c.Push_Date__c);
        }
    }

    static testMethod void testUpdateAccountNegativeMoreThan200LessThan1000(){
        // Test data setup
        Account acc = TestSetupHelper.generateAccountList(1, true)[0];// Generate one Account
        List<Contact> contList = TestSetupHelper.generateContactList(600, acc.Id, true);
        System.debug('Account Created: ' + acc.Name);
        System.debug('Contacts Created: ' + contList.size());
        // Actual test
        Test.startTest();
        acc.Push_To_Vendor__c = 'No';
        UpdateContactQueue updatequeue = new UpdateContactQueue(contList,acc);
        Id queue = System.enqueueJob(updatequeue);
        // update acc;
        Test.stopTest();
        System.assertEquals(600, contList.size());
        List<Contact> contacts = [SELECT Id, Push_Date__c
                                  FROM Contact
                                  WHERE AccountId = :acc.Id];
        for (Contact c : contacts){
            System.assertEquals(null, c.Push_Date__c);
        }
    }

    static testMethod void testUpdateAccountPositiveMoreThan1000(){
        // Test data setup
        Account acc = TestSetupHelper.generateAccountList(1, true)[0];// Generate one Account
        List<Contact> contList = TestSetupHelper.generateContactList(150, acc.Id, true);
        System.debug('Account Created: ' + acc.Name);
        System.debug('Contacts Created: ' + contList.size());
        // Actual test
        Test.startTest();
        acc.Push_To_Vendor__c = 'Yes';
        Database.executeBatch(new UpdateContactBatch(contList,acc), 150);
        //update acc;
        Test.stopTest();
        System.assertEquals(150, contList.size()); // Only using 150 for test
        List<Contact> contacts = [SELECT Id, Push_Date__c
                                  FROM Contact
                                  WHERE AccountId = :acc.Id];
        for (Contact c : contacts){
            System.assertNotEquals(null, c.Push_Date__c);
            System.debug(c.Push_Date__c);
        }
    }

    static testMethod void testUpdateAccountNegativeMoreThan1000(){
        // Test data setup
        Account acc = TestSetupHelper.generateAccountList(1, true)[0];// Generate one Account
        List<Contact> contList = TestSetupHelper.generateContactList(1200, acc.Id, true);
        System.debug('Account Created: ' + acc.Name);
        System.debug('Contacts Created: ' + contList.size());
        // Actual test
        Test.startTest();
        acc.Push_To_Vendor__c = 'No';
        //UpdateContactBatch up = new UpdateContactBatch(contList,acc);
        Database.executeBatch(new UpdateContactBatch(contList,acc), 150);
        //update acc;
        Test.stopTest();
        System.assertEquals(1200, contList.size());
        List<Contact> contacts = [SELECT Id, Push_Date__c
                                  FROM Contact
                                  WHERE AccountId = :acc.Id];
        for (Contact c : contacts){
            System.assertEquals(null, c.Push_Date__c);
        }
    }

    static testMethod void testDeleteAccount(){
        // Test data setup
        Account acc = TestSetupHelper.generateAccountList(1, true)[0];
        // Actual test
        Test.startTest();
        delete acc;
        Test.stopTest();

        // Asserts
    }

}