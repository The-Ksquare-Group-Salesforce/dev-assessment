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
    
    
}