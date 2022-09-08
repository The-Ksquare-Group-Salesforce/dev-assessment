@IsTest
public with sharing class UpdateContactsBatchTest {
	@TestSetup static void makeTestData(){
        
        Account acc = new Account(
            Name = 'Test Acc 2000 No',
            Push_To_Vendor__c = 'No'
        );
        insert acc;
        
        Contact con;
        List<Contact> cons = new List<Contact>();
        
        for(integer i = 1; i <= 2000; i++){
            con = new Contact(
            	LastName = ('Test Acc 2000 No ' + i),
                AccountId = acc.id,
                Push_Date__c = null
            );
            cons.add(con);
        }
        insert cons;
    }
    
    @isTest static void test(){
        list<Contact> cons = [select id, Push_Date__c from Contact];
        map<id, dateTime> consMap = new map<id, dateTime>();
        DateTime dateT = DateTime.Now();
        for(Contact c : cons){
            consMap.put(c.id, dateT);
        }
        Test.startTest();
        UpdateContactsBatch batch = new UpdateContactsBatch(consMap);
        database.executeBatch(batch,150);
        Test.stopTest();
        List<Contact> consU = [SELECT Id, Push_Date__c FROM Contact];
        integer count = 0;
        for(Contact c : consU){
            if(c.Push_Date__c != null){
                count += 1;
            }
        }
        system.assertEquals(150, count);
    }
}