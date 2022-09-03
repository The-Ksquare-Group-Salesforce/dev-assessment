@isTest
public with sharing class UpdateAccContactsAsyncTest {

    @TestSetup
    static void setup(){
        List<Account> testAccList = new List<Account>();

        //inserting Accounts
        for(Integer i = 0; i < 1005; i++){
            Account acc = new Account(Name = 'Test Account' + i);
            testAccList.add(acc);
        }
        insert testAccList; 
        
        //inserting Contancts
        List<Contact> testConList = new List<Contact>();
        for(Account acc : testAccList){
            for(Integer j = 0; j < 3; j++){
                testConList.add(new Contact (LastName = acc.Name + 'Contact' + j, AccountId = acc.Id));
            }
        }
        insert testConList;        
    }

    @isTest
    public static void UpdateAccContactsAsyncTestMethod() {
        Set<Id> accIds = new Set<Id>();
        List<Account> accList = [SELECT Id, PushToVendor__c FROM Account WHERE Name LIKE '%Test%'];
       
        for (Account acc : accList) {
            acc.PushTovendor__c = 'Yes';
        }

        Database.update(accList,false);
        accIds = (new Map<Id,Account>(accList)).keySet();

        Test.startTest();
        UpdateAccContactsAsync async = new UpdateAccContactsAsync(accIds);
        Id contactQueue = System.enqueueJob(async);
        Test.stopTest();

        System.assertEquals(3015, [SELECT COUNT() FROM Contact WHERE AccountId IN :accIds AND Push_Date__c != NULL]);
    }
}
