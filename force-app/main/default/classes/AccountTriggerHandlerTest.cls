@isTest
public with sharing class AccountTriggerHandlerTest {
    
    // public AccountTriggerHandlerTest() {
    // }  
    @isTest
    private static void beforeUpdateAccountHandlerPositiveTest(){

        Account acc = new Account();
        Boolean verificationVar = True;
        List<Contact> contactsToUpdateTest = new List<Contact>();
        acc.Name= 'TestAccount';
        
        Insert acc;

        acc = [SELECT Name, Id FROM Account WHERE Name = 'TestAccount' LIMIT 1];

        for (Integer i=0; i <= 5; i++) {
            
            Contact contTest = new Contact();
            contTest.LastName = 'TestContact ' + i;
            contTest.AccountId = acc.Id;
            contactsToUpdateTest.add(contTest);
        }

        Insert contactsToUpdateTest;

        acc.Push_To_Vendor__c = 'Yes';
        
        Update acc;

        contactsToUpdateTest = [SELECT Id, AccountId, Push_Date__c FROM Contact WHERE AccountId =: acc.Id];

        for (Contact cont : contactsToUpdateTest) {
            
            if (cont.Push_Date__c == Null) {
                
                verificationVar = False;
            }
        }

        System.assertEquals(True, verificationVar,'Update was correct');

    }
    @isTest
    private static void beforeUpdateAccountHandlerNegativeTest(){

        Account acc = new Account();
        Boolean verificationVar = True;
        List<Contact> contactsToUpdateTest = new List<Contact>();
        acc.Name= 'TestAccount';
        acc.Push_To_Vendor__c = 'Yes';
        
        Insert acc;

        acc = [SELECT Name, Id FROM Account WHERE Name = 'TestAccount' LIMIT 1];

        for (Integer i=0; i <= 5; i++) {
            
            Contact contTest = new Contact();
            contTest.LastName = 'TestContact ' + i;
            contTest.AccountId = acc.Id;
            contactsToUpdateTest.add(contTest);
        }

        Insert contactsToUpdateTest;

        acc.Push_To_Vendor__c = 'No';

        Update acc;

        contactsToUpdateTest = [SELECT Id, AccountId, Push_Date__c FROM Contact WHERE AccountId =: acc.Id];

        for (Contact cont : contactsToUpdateTest) {
            
            if (cont.Push_Date__c != Null) {
                
                verificationVar = False;
            }
        }

        System.assertEquals(True, verificationVar,'Update was correct');

    }

}
