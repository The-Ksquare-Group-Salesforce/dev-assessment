@isTest
public class firstCaseUpdateTest {
    @testSetup
    static void DataFactory(){
        
        Account acc = new Account(
            Name = 'Juan more than 200 and less than 1000',
            Type = 'Prospect'
            
        );
        
        insert acc;
        
        List<Contact>conList = new List<Contact>();
        for(integer i=0; i<200; i++){
            Contact con = new Contact(
                LastName = 'Le Contact test ' + i,
                AccountId = acc.Id
            ); 
        }
        
        
        insert conList;
            List<Contact>conList2 = new List<Contact>();
        for(integer i=200; i<400; i++){
            Contact con = new Contact(
                LastName = 'Le Contact test ' + i,
                AccountId = acc.Id
            ); 
        }
        
        
        insert conList2;
        
        
    
        
    }
    
    
    @isTest
    static void checkUpdatesMoreThan200andLessThan1000Yes(){
        
        Account acc = [select id, PushToVendor__c from Account where Name = 'Juan more than 200 and less than 1000' limit 1];
        acc.PushToVendor__c = 'Yes';
        List<id> contactListYes = new List<id>();
        contactListYes.add(acc.Id);
        firstCaseUpdate updater = new firstCaseUpdate(contactListYes,'Yes');
        
        Test.startTest(); 
        update acc;
        System.enqueueJob(updater); 
        Test.stopTest();  
        
        
        Contact con =  [select id, Push_Date__c from contact where accountId =: acc.Id limit 1];
        System.assertEquals(Date.today(), con.Push_Date__c);
        
        
    }
    
    
    @isTest
    static void checkUpdatesMoreThan200andLessThan1000No(){
        
        Account acc = [select id, PushToVendor__c from Account where Name = 'Juan more than 200 and less than 1000' limit 1];
        acc.PushToVendor__c = 'No';
        
        List<id> contactListNo = new List<id>();
        contactListNo.add(acc.Id);
        firstCaseUpdate updater = new firstCaseUpdate(contactListNo,'No');
        
        Test.startTest(); 
        update acc;
        System.enqueueJob(updater); 
        Test.stopTest();  
        
        
       Contact con =  [select id, Push_Date__c from contact where accountId =: acc.Id limit 1];
       System.assertEquals(null, con.Push_Date__c);
    }
    
    
}