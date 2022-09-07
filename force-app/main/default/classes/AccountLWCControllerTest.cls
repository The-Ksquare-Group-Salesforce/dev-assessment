@isTest
public with sharing class AccountLWCControllerTest {
    @TestSetup static void makeTestData(){ 
        Account acc = new Account(
            Name = 'Test Acc 100 No',
            Push_To_Vendor__c = 'No'
        );
        insert acc;
        list<Contact> cons = new list<Contact>();
        Contact con;
        for(integer i = 1; i <= 100; i++){
            con = new Contact(
            	LastName = ('Test Acc 100 No ' + i),
                AccountId = acc.id
            );
            cons.add(con);
        }
        insert cons;
    }
    @isTest static void getContacts(){
        Account acc = [select id, Push_To_Vendor__c from Account where Name = 'Test Acc 100 No' limit 1];
        string sId = acc.id;
        test.startTest();
        list<Contact> cons = AccountLWCController.getContacts(sId, '');
        test.stopTest();
        system.assertEquals(100, cons.size());
    }
    
}
