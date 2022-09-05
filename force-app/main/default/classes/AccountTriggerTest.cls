@IsTest
public with sharing class AccountTriggerTest{
    public AccountTriggerTest(){
    }

    /**
     * generateAccountList Description
     *
     * @param count (Integer): Number of records to create
     * @param doInsert (Boolean): Do de DML Inserition
     *
     * @return List<Account>: List of the accounts created
     */
    public static List<Account> generateAccountList(final Integer count, final Boolean doInsert){

        List<Account> accountList = new List<Account>();
        for (Integer i = 0; i < count; i++){
            accountList.add(new Account(Name = 'Test Account' + i, Phone = '809-220-1234'));
        }

        if (doInsert){
            insert accountList;
        }

        return accountList;
    }

    /**
     * createContactList Description
     *
     * @param recordCount (Integer): Number of records to create
     * @param accountId (Id): Account relation
     * @param doInsert (Boolean): Write the parameter description
     *
     * @return List<Contact>: List of the accounts created
     */
    public static List<Contact> generateContactList(final Integer recordCount, final Id accountId, final Boolean doInsert){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        List<Contact> contactList = new List<Contact>();
        if (recordCount < 200){
            for (Integer i = 0; i < recordCount; i++){
                contactList.add(new Contact(FirstName = 'Hello' + i, LastName = 'World' + i, Email = 'frangel@ksquare.com', AccountId = accountId));
            }

            if (doInsert){
                insert contactList;
            }
        } else{            
            for (Integer i = 0; i < recordCount; i = i+ 200){
                List<Contact> tempContactList = new List<Contact>();//clear flag each iteration
                for (Integer j = 0; j < 200; j++){
                    tempContactList.add(new Contact(FirstName = i+'Hello' + j, LastName = i+'World' + j, Email = 'frangel@ksquare.com', AccountId = accountId));
                }
                Database.insert(tempContactList,dml);
                contactList.addAll(tempContactList);
            }
        }
        return contactList;
    }

    static testMethod void testUpdateAccountPositiveLessThan200(){
        // Test data setup
        Account acc = generateAccountList(1, true)[0];// Generate one Account
        List<Contact> contList = generateContactList(199, acc.Id, true);
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
        Account acc = generateAccountList(1, true)[0];// Generate one Account
        List<Contact> contList = generateContactList(199, acc.Id, true);
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
        Account acc = generateAccountList(1, true)[0];// Generate one Account
        List<Contact> contList = generateContactList(150, acc.Id, true);
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
        Account acc = generateAccountList(1, true)[0];// Generate one Account
        List<Contact> contList = generateContactList(600, acc.Id, true);
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
        Account acc = generateAccountList(1, true)[0];// Generate one Account
        List<Contact> contList = generateContactList(150, acc.Id, true);
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
        Account acc = generateAccountList(1, true)[0];// Generate one Account
        List<Contact> contList = generateContactList(1200, acc.Id, true);
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
        Account acc = generateAccountList(1, true)[0];
        // Actual test
        Test.startTest();
        delete acc;
        Test.stopTest();

        // Asserts
    }

}