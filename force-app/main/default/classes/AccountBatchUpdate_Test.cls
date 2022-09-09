@isTest
public with sharing class AccountBatchUpdate_Test {
    @TestSetup
    static void makeData(){
        List<Account> accts = new List<Account>();
        for(Integer i=0;i<10;i++) {
            Account a = new Account(Name='TestAccount' + i,PushToVendor__c = 'No');
            accts.add(a);
        }
        insert accts;
        List<Contact> newContacts = new List<Contact>();
        for (Integer j=0;j<accts.size();j++) {
            Account acct = accts[j];
            //insert 50 related contacts per account created
            for (Integer k=0;k<50;k++) {
                newContacts.add(new Contact(LastName=acct.Name + ' Contact ' + k,
                                            Push_Date__c=null,
                                            AccountId=acct.Id));
            }
        }
        insert newContacts;
        //return accts;
        
    }
        public static List<Account> updateAccountsBatch(List<Account> accts , String pushToVendor, Integer numAccsToUpdate) {
            List<Account> updateAccounts =  [SELECT Id,PushToVendor__c FROM Account WHERE Id IN :accts];
                for (Integer j=0;j<numAccsToUpdate;j++){
                    updateAccounts[j].PushToVendor__c = pushToVendor;
                }
                return updateAccounts;
        }
    @isTest
    static void batchExecutionTest() {
        makeData();
        List<Account> insertedAccts = [SELECT Id FROM Account LIMIT 10];
        List<Account> updatedAccounts= updateAccountsBatch(insertedAccts,'Yes', 10);
        update updatedAccounts;
        Test.startTest();
        AccountBatchUpdate myBatchObject = new AccountBatchUpdate(updatedAccounts);
        Id batchId = Database.executeBatch(myBatchObject, 500);
        Test.stopTest();
        List<Contact> relatedContacts =  [SELECT Id FROM Contact WHERE Push_Date__c !=null];
        System.assertEquals(500, relatedContacts.size());
    }
}