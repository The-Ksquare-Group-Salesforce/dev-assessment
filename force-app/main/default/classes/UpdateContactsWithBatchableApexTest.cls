@isTest
public with sharing class UpdateContactsWithBatchableApexTest {

    @isTest
    private static void beforeUpdateAccountHandlerPositiveTestBatchApex(){

        
        Boolean verificationVar = True;
        List<Account> accsToUpdateTest = new List<Account>();
        List<Contact> contactsToUpdateTest = new List<Contact>();
      
        For(Integer i=0; i < 3; i++){
            Account acc = new Account();
            acc.Name= 'TestAccount';
            accsToUpdateTest.add(acc);
        }
        
        Insert accsToUpdateTest;

        accsToUpdateTest.clear();

        Map<Id,Account> accsToUpdateMapTest = new Map<Id,Account>([SELECT Id, Name FROM Account WHERE Name = 'TestAccount' LIMIT 5]);

        for (Account acc: accsToUpdateMapTest.values()) {
            
            for (Integer i=0; i < 500; i++) {
                Contact contTest = new Contact();
                contTest.LastName = 'TestContact ' + i;
                contTest.AccountId = acc.Id;
                contactsToUpdateTest.add(contTest);
            }
        }

        Insert contactsToUpdateTest;

        for (Account acc: accsToUpdateMapTest.values()) {
            
            acc.Push_To_Vendor__c = 'Yes';
            accsToUpdateTest.add(acc);

        }

        Test.startTest();
        Update accsToUpdateTest;
        Test.stopTest();

        contactsToUpdateTest = [SELECT Id, AccountId, Push_Date__c FROM Contact WHERE AccountId =: accsToUpdateMapTest.keySet()];

        for (Contact cont : contactsToUpdateTest) {
            
            if (cont.Push_Date__c == Null) {
                
                verificationVar = False;
            }
        }

        System.assertEquals(True, verificationVar,'Update was correct');
    }

    @isTest
    private static void beforeUpdateAccountHandlerNegativeTestBatchApex(){

        
        Boolean verificationVar = True;
        List<Account> accsToUpdateTest = new List<Account>();
        List<Contact> contactsToUpdateTest = new List<Contact>();
      
        For(Integer i=0; i < 3; i++){
            Account acc = new Account();
            acc.Name= 'TestAccount';
            acc.Push_To_Vendor__c = 'Yes';
            accsToUpdateTest.add(acc);
        }
        
        Insert accsToUpdateTest;

        accsToUpdateTest.clear();

        Map<Id,Account> accsToUpdateMapTest = new Map<Id,Account>([SELECT Id, Name FROM Account WHERE Name = 'TestAccount' LIMIT 5]);

        for (Account acc: accsToUpdateMapTest.values()) {
            
            for (Integer i=0; i < 500; i++) {
                Contact contTest = new Contact();
                contTest.LastName = 'TestContact ' + i;
                contTest.AccountId = acc.Id;
                contactsToUpdateTest.add(contTest);
            }
        }

        Insert contactsToUpdateTest;

        for (Account acc: accsToUpdateMapTest.values()) {
            
            acc.Push_To_Vendor__c = 'No';
            accsToUpdateTest.add(acc);

        }

        Test.startTest();
        Update accsToUpdateTest;
        Test.stopTest();

        contactsToUpdateTest = [SELECT Id, AccountId, Push_Date__c FROM Contact WHERE AccountId =: accsToUpdateMapTest.keySet()];

        for (Contact cont : contactsToUpdateTest) {
            
            if (cont.Push_Date__c != Null) {
                
                verificationVar = False;
            }
        }

        System.assertEquals(True, verificationVar,'Update was correct');
    }
}
