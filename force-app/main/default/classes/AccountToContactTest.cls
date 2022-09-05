@isTest
public class AccountToContactTest {
    
    @testSetup
    static void DataFactory(){
        
        Account acc = new Account(
            Name = 'Pepe two hundred',
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
        
        
        
        Account accCase1 = new Account(
            Name = 'Juan more than 200 and less than 1000',
            Type = 'Prospect'
            
        );
        
        insert accCase1;
        
        List<Contact>conList2 = new List<Contact>();
        for(integer i=0; i<200; i++){
            Contact con = new Contact(
                LastName = 'Testing first Case ' + i,
                AccountId = accCase1.Id
            ); 
        }
        
        
        insert conList2;
        
        List<Contact>conList3 = new List<Contact>();
        for(integer i=200; i<400; i++){
            Contact con = new Contact(
                LastName = 'Testing first Case ' + i,
                AccountId = accCase1.Id
            ); 
        }
        
        
        insert conList3;
        
        List<Contact>conList4 = new List<Contact>();
        for(integer i=400; i<600; i++){
            Contact con = new Contact(
                LastName = 'Testing first Case ' + i,
                AccountId = accCase1.Id
            ); 
        }
        
        insert conList4;
        
        List<Contact>conList5 = new List<Contact>();
        for(integer i=600; i<800; i++){
            Contact con = new Contact(
                LastName = 'Testing first Case ' + i,
                AccountId = accCase1.Id
            ); 
        }
        
        insert conList5;
        
        List<Contact>conList6 = new List<Contact>();
        for(integer i=800; i<1000; i++){
            Contact con = new Contact(
                LastName = 'Testing first Case ' + i,
                AccountId = accCase1.Id
            ); 
        }
        
        insert conList6;
        
        
        Account accCase2 = new Account(
            Name = 'Pepe one Thousand',
            Type = 'Prospect'
            
        );
        
        insert accCase2;
        
        List<Contact>conList7 = new List<Contact>();
        for(integer i=0; i<200; i++){
            Contact con = new Contact(
                LastName = 'Testing Second Case ' + i,
                AccountId = accCase2.Id
            ); 
        }
        
        
        insert conList7;
        
        List<Contact>conList8 = new List<Contact>();
        for(integer i=200; i<400; i++){
            Contact con = new Contact(
                LastName = 'Testing Second Case ' + i,
                AccountId = accCase2.Id
            ); 
        }
        
        
        insert conList8;
        
        List<Contact>conList9 = new List<Contact>();
        for(integer i=400; i<600; i++){
            Contact con = new Contact(
                LastName = 'Testing Second Case ' + i,
                AccountId = accCase2.Id
            ); 
        }
        
        
        insert conList9;
        
        List<Contact>conList10 = new List<Contact>();
        for(integer i=600; i<800; i++){
            Contact con = new Contact(
                LastName = 'Testing Second Case ' + i,
                AccountId = accCase2.Id
            ); 
        }
        
        
        insert conList10;
        
        List<Contact>conList11 = new List<Contact>();
        for(integer i=800; i<1000; i++){
            Contact con = new Contact(
                LastName = 'Testing Second Case ' + i,
                AccountId = accCase2.Id
            ); 
        }
        
        
        insert conList11;
        
        List<Contact>conList12 = new List<Contact>();
        for(integer i=1000; i<1100; i++){
            Contact con = new Contact(
                LastName = 'Testing Second Case ' + i,
                AccountId = accCase2.Id
            ); 
        }
        
        
        insert conList12;
        
    }
    /////End of data setUp
    
    @isTest
    static void checkUpdatesLessThan200No(){
        //Test for less than 200 contacts
        Account acc = [select id, PushToVendor__c from Account where Name = 'Pepe two hundred' limit 1];
        acc.PushToVendor__c = 'No';
        Test.startTest();
        update acc;
        Test.stopTest();  
        
        Contact con =  [select id, Push_Date__c from contact where accountId =: acc.Id limit 1];
        System.assertEquals(null, con.Push_Date__c);
    }
    
    @isTest
    static void checkUpdatesLessThan200Yes(){
        //Test for less than 200 contacts
        Account acc = [select id, PushToVendor__c from Account where Name = 'Pepe two hundred' limit 1];
        acc.PushToVendor__c = 'Yes';
        Test.startTest();
        update acc;
        Test.stopTest();
        
        Contact con =  [select id, Push_Date__c from contact where accountId =: acc.Id limit 1];
        System.assertEquals(Date.today(), con.Push_Date__c);
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
    
    
    @isTest
    static void checkUpdatesMoreThanOneThousandNo(){
        
        Account acc = [select id, PushToVendor__c from Account where Name = 'Pepe one Thousand' limit 1];
        acc.PushToVendor__c = 'No';
        
        List<id> contactListNo = new List<id>();
        contactListNo.add(acc.Id);
        
        
        
        Test.startTest(); 
        update acc;
        secondCaseUpdate myBatchObj = new secondCaseUpdate(contactListNo,'No');
        Id batchId = Database.executeBatch(myBatchObj, 150); 
        Test.stopTest();  
        
        
      // Contact con =  [select id, Push_Date__c from contact where accountId =: acc.Id limit 1];
     //System.assertEquals(null, con.Push_Date__c);
    }
    
    
     @isTest
    static void checkUpdatesMoreThanOneThousandYes(){
        
        Account acc = [select id, PushToVendor__c from Account where Name = 'Pepe one Thousand' limit 1];
        acc.PushToVendor__c = 'Yes';
        
        List<id> contactListYes = new List<id>();
        contactListYes.add(acc.Id);
        
        
        
        Test.startTest(); 
        update acc;
        secondCaseUpdate myBatchObj = new secondCaseUpdate(contactListYes,'Yes');
        Id batchId = Database.executeBatch(myBatchObj, 150); 
        Test.stopTest();  
        
        
       //Contact con =  [select id, Push_Date__c from contact where accountId =: acc.Id limit 1];
       // System.assertEquals(Date.today(), con.Push_Date__c);
    }
}