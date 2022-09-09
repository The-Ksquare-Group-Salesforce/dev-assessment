@isTest
public class AccountTriggerHandler_Test {
    @TestSetup
    static void makeData(){
            List<Account> accts = new List<Account>();
            for(Integer i=0;i<50;i++) {
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
    
    public static void updateAccounts(List<Account> accts , String pushToVendor, Integer numAccsToUpdate) {
        List<Account> updateAccounts =  [SELECT Id,PushToVendor__c FROM Account WHERE Id IN :accts];
            for (Integer j=0;j<numAccsToUpdate;j++){
                updateAccounts[j].PushToVendor__c = pushToVendor;
            }
            update updateAccounts;
    }
    public static List<Account> updateAccountsBatch(List<Account> accts , String pushToVendor, Integer numAccsToUpdate) {
        List<Account> updateAccounts =  [SELECT Id,PushToVendor__c FROM Account WHERE Id IN :accts];
            for (Integer j=0;j<numAccsToUpdate;j++){
                updateAccounts[j].PushToVendor__c = pushToVendor;
            }
            return updateAccounts;
    }

    
    @isTest
    static void updateContatSyncTestPositive(){
        Test.startTest();
        List<Account> insertedAccts = [SELECT Id FROM Account LIMIT 3];
        updateAccounts(insertedAccts,'Yes', insertedAccts.size());
        Test.stopTest();
        List<Contact> relatedContacts =  [SELECT Id FROM Contact WHERE Push_Date__c =: date.today()];
        System.assertEquals(150, relatedContacts.size());

    }
   @isTest
    static void updateContatSyncTestNevative(){
        Test.startTest();
        List<Account> insertedAccts = [SELECT Id FROM Account LIMIT 3];
        updateAccounts(insertedAccts,'No', insertedAccts.size());
        Test.stopTest();
        List<Contact> relatedContacts =  [SELECT Id FROM Contact WHERE Push_Date__c =NULL];
        System.assertNotEquals(150, relatedContacts.size());

    }

    @isTest
    static void updateContatAsyncTestPositive(){
        List<Account> insertedAccts = [SELECT Id FROM Account LIMIT 19];
        Test.startTest();
        System.debug(1);
        updateAccounts(insertedAccts,'Yes', insertedAccts.size());//200 - 1000
        Test.stopTest();
        List<Contact> relatedContacts =  [SELECT Id FROM Contact WHERE Push_Date__c !=null];
        System.assertEquals(950, relatedContacts.size());

    }
    @isTest
    static void updateContatAsyncTestNegative(){
        List<Account> insertedAccts = [SELECT Id FROM Account LIMIT 19];
        Test.startTest();
        updateAccounts(insertedAccts,'No', insertedAccts.size());//200 - 1000
        Test.stopTest();
        List<Contact> relatedContacts =  [SELECT Id FROM Contact WHERE Push_Date__c =NULL];
        System.assertNotEquals(950, relatedContacts.size());
    }
}