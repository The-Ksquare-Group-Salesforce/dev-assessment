@isTest
public class secondCaseTest {

       @testSetup
    static void DataFactory(){
        
        Account acc = new Account(
            Name = 'Pepe one Thousand',
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
        
        List<Contact>conList3 = new List<Contact>();
        for(integer i=400; i<600; i++){
            Contact con = new Contact(
                LastName = 'Le Contact test ' + i,
                AccountId = acc.Id
            ); 
        }
        
        
        insert conList3;
        
         List<Contact>conList4 = new List<Contact>();
        for(integer i=600; i<800; i++){
            Contact con = new Contact(
                LastName = 'Le Contact test ' + i,
                AccountId = acc.Id
            ); 
        }
        
        
        insert conList4;
    
          List<Contact>conList5 = new List<Contact>();
        for(integer i=800; i<1000; i++){
            Contact con = new Contact(
                LastName = 'Le Contact test ' + i,
                AccountId = acc.Id
            ); 
        }
        
        
        insert conList5;
        
         List<Contact>conList6 = new List<Contact>();
        for(integer i=1000; i<1100; i++){
            Contact con = new Contact(
                LastName = 'Le Contact test ' + i,
                AccountId = acc.Id
            ); 
        }
        
        
        insert conList6;
    } 
    @isTest
    static void checkUpdatesMoreThanOneThousandNo(){
        
        Account acc = [select id, PushToVendor__c from Account where Name = 'Pepe one Thousand' limit 1];
        acc.PushToVendor__c = 'No';
        
      
        List<Id> contactListNo = new List<Id>(); 
        contactListNo.add(acc.id);
        
        
        Test.startTest(); 
        update acc;
        secondCaseUpdate myBatchObj = new secondCaseUpdate(contactListNo,'No');
        Id batchId = Database.executeBatch(myBatchObj, 150); 
        Test.stopTest();  
        
        
     Contact con =  [select id, Push_Date__c from contact where accountId =: acc.Id limit 1];
     System.assertEquals(null, con.Push_Date__c);
    }
    
    
     @isTest
    static void checkUpdatesMoreThanOneThousandYes(){
        
        Account acc = [select id, PushToVendor__c from Account where Name = 'Pepe one Thousand' limit 1];
        acc.PushToVendor__c = 'Yes';
        
       List<Id> contactListYes = new List<Id>();
        contactListYes.add(acc.Id);
        
      
        
        Test.startTest(); 
        update acc;
        secondCaseUpdate myBatchObj = new secondCaseUpdate(contactListYes,'Yes');
        Id batchId = Database.executeBatch(myBatchObj, 150); 
        Test.stopTest();  
        
        
      Contact con =  [select id, Push_Date__c from contact where accountId =: acc.Id limit 1];
       System.assertEquals(Date.today(), con.Push_Date__c);
    }
}