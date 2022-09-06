@isTest
public with sharing class AccountTriggerHandlerTest {
    @TestSetup static void makeTestData(){
        
        Account acc;
        Contact con;
        
        list<Account> accs = new list<Account>();
        list<Contact> cons = new list<Contact>();
        
        
        acc = new Account(
            Name = 'Test Acc 100 No',
            Push_To_Vendor__c = 'No'
        );
        accs.add(acc);
        acc = new Account(
            Name = 'Test Acc 100 Yes',
            Push_To_Vendor__c = 'Yes'
        );
        accs.add(acc);
        acc = new Account(
            Name = 'Test Acc 500 No',
            Push_To_Vendor__c = 'No'
        );
        accs.add(acc);
        acc = new Account(
            Name = 'Test Acc 500 Yes',
            Push_To_Vendor__c = 'Yes'
        );
        accs.add(acc);
        acc = new Account(
            Name = 'Test Acc 2000 No',
            Push_To_Vendor__c = 'No'
        );
        accs.add(acc);
        acc = new Account(
            Name = 'Test Acc 2000 Yes',
            Push_To_Vendor__c = 'Yes'
        );
        accs.add(acc);
        acc = new Account(
            Name = 'Test Acc 0',
            Push_To_Vendor__c = 'No'
        );
        accs.add(acc);
        
        insert accs;
        
        
        for(integer i = 1; i <= 100; i++){
            con = new Contact(
            	LastName = ('Test Acc 100 No ' + i),
                AccountId = accs[0].id
            );
            cons.add(con);
        }
        for(integer i = 1; i <= 100; i++){
            con = new Contact(
            	LastName = ('Test Acc 100 Yes ' + i),
                AccountId = accs[1].id
            );
            cons.add(con);
        }
        for(integer i = 1; i <= 500; i++){
            con = new Contact(
            	LastName = ('Test Acc 500 No ' + i),
                AccountId = accs[2].id
            );
            cons.add(con);
        }
        for(integer i = 1; i <= 500; i++){
            con = new Contact(
            	LastName = ('Test Acc 500 Yes ' + i),
                AccountId = accs[3].id
            );
            cons.add(con);
        }
        for(integer i = 1; i <= 2000; i++){
            con = new Contact(
            	LastName = ('Test Acc 2000 No ' + i),
                AccountId = accs[4].id
            );
            cons.add(con);
        }
        for(integer i = 1; i <= 2000; i++){
            con = new Contact(
            	LastName = ('Test Acc 2000 Yes ' + i),
                AccountId = accs[5].id
            );
            cons.add(con);
        }
        insert cons;
    }
	
    @isTest static void test100NoToYes(){
        Account acc = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 100 No' limit 1];
        test.startTest();
        acc.Push_To_Vendor__c = 'Yes';
        update acc;
        test.stopTest();
       	list<Contact> cons = [select id, Push_Date__c from Contact where AccountId = :acc.id];
        for(Contact c : cons){
            system.assertNotEquals(NULL, c.Push_Date__c);
        }
    }
    
    @isTest static void test100YesToNo(){
        Account acc = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 100 Yes' limit 1];
        test.startTest();
        acc.Push_To_Vendor__c = 'No';
        update acc;
        test.stopTest();
       	list<Contact> cons = [select id, Push_Date__c from Contact where AccountId = :acc.id];
        for(Contact c : cons){
            system.assertEquals(NULL, c.Push_Date__c);
        }
    }
    
    @isTest static void test100NoToYesAnd100YesToNo(){
        Account acc1 = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 100 No' limit 1];
        Account acc2 = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 100 Yes' limit 1];
        list<Account> accs = new list<Account>();
        test.startTest();
        acc1.Push_To_Vendor__c = 'Yes';
        acc2.Push_To_Vendor__c = 'No';
        accs.add(acc1);
        accs.add(acc2);
        update accs;
        test.stopTest();
       	list<Contact> cons1 = [select id, Push_Date__c from Contact where AccountId = :acc1.id];
        for(Contact c : cons1){
            system.assertNotEquals(NULL, c.Push_Date__c);
        }
        list<Contact> cons2 = [select id, Push_Date__c from Contact where AccountId = :acc2.id];
        for(Contact c : cons2){
            system.assertEquals(NULL, c.Push_Date__c);
        }
    }
    
    @isTest static void testNoRun(){
        Account acc = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 100 No' limit 1];
        test.startTest();
        acc.Push_To_Vendor__c = 'No';
        update acc;
        test.stopTest();
       	list<Contact> cons = [select id, Push_Date__c from Contact where AccountId = :acc.id];
        for(Contact c : cons){
            system.assertEquals(NULL, c.Push_Date__c);
        }
    }
    
    @isTest static void test0Contacts(){
        Account acc = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 0' limit 1];
        test.startTest();
        acc.Push_To_Vendor__c = 'Yes';
        update acc;
        test.stopTest();
       	list<Contact> cons = [select id, Push_Date__c from Contact where AccountId = :acc.id];
        system.assertEquals(0, cons.size());
    }
    
    @isTest static void test500NoToYes(){
        Account acc = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 500 No' limit 1];
        test.startTest();
        acc.Push_To_Vendor__c = 'Yes';
        update acc;
        test.stopTest();
       	list<Contact> cons = [select id, Push_Date__c from Contact where AccountId = :acc.id];
        for(Contact c : cons){
            system.assertNotEquals(NULL, c.Push_Date__c);
        }
    }
    
    @isTest static void test500YesToNo(){
        Account acc = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 500 Yes' limit 1];
        test.startTest();
        acc.Push_To_Vendor__c = 'No';
        update acc;
        test.stopTest();
       	list<Contact> cons = [select id, Push_Date__c from Contact where AccountId = :acc.id];
        for(Contact c : cons){
            system.assertEquals(NULL, c.Push_Date__c);
        }
    }
    
    @isTest static void test500NoToYesAnd500YesToNo(){
        Account acc1 = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 500 No' limit 1];
        Account acc2 = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 500 Yes' limit 1];
        list<Account> accs = new list<Account>();
        test.startTest();
        acc1.Push_To_Vendor__c = 'Yes';
        acc2.Push_To_Vendor__c = 'No';
        accs.add(acc1);
        accs.add(acc2);
        update accs;
        test.stopTest();
       	list<Contact> cons1 = [select id, Push_Date__c from Contact where AccountId = :acc1.id];
        for(Contact c : cons1){
            system.assertNotEquals(NULL, c.Push_Date__c);
        }
        list<Contact> cons2 = [select id, Push_Date__c from Contact where AccountId = :acc2.id];
        for(Contact c : cons2){
            system.assertEquals(NULL, c.Push_Date__c);
        }
    }
    
    @isTest static void test2000NoToYes(){
        Account acc = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 2000 No' limit 1];
        test.startTest();
        acc.Push_To_Vendor__c = 'Yes';
        update acc;
        test.stopTest();
       	list<Contact> cons = [select id, Push_Date__c from Contact where AccountId = :acc.id];
        integer processedContacts = 0;
        for(Contact c : cons){
            if(c.Push_Date__c != NULL){
                processedContacts += 1;
            }
        }
        system.assertEquals(150, processedContacts);
    }
    
    @isTest static void test2000YesToNo(){
        Account acc = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 2000 Yes' limit 1];
        test.startTest();
        acc.Push_To_Vendor__c = 'No';
        update acc;
        test.stopTest();
       	list<Contact> cons = [select id, Push_Date__c from Contact where AccountId = :acc.id];
        integer processedContacts = 0;
        for(Contact c : cons){
            if(c.Push_Date__c == NULL){
                processedContacts += 1;
            }
        }
        system.assertEquals(1850, processedContacts);
    }
    
    @isTest static void test2000NoToYesAnd500YesToNo(){
        Account acc1 = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 2000 No' limit 1];
        Account acc2 = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 2000 Yes' limit 1];
        list<Account> accs = new list<Account>();
        test.startTest();
        acc1.Push_To_Vendor__c = 'Yes';
        acc2.Push_To_Vendor__c = 'No';
        accs.add(acc1);
        accs.add(acc2);
        update accs;
        test.stopTest();
       	list<Contact> cons1 = [select id, Push_Date__c from Contact where AccountId = :acc1.id];
        integer processedContacts = 0;
        for(Contact c : cons1){
			if(c.Push_Date__c != NULL){
                processedContacts += 1;
            }            
        }
        list<Contact> cons2 = [select id, Push_Date__c from Contact where AccountId = :acc2.id];
        for(Contact c : cons2){
            if(c.Push_Date__c == NULL){
                processedContacts += 1;
            }
        }
        system.assertEquals(2150, processedContacts);
    }
}