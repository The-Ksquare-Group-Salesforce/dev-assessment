@isTest
public with sharing class AccountTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        List<Account> accList = new List<Account>();
    
        for (Integer i=0;i<2000;i++) {
            Account account = new Account(Name = 'Account ' + i);
            accList.add(account);
        }
        insert accList;
    
        List<Contact> conList = new List<Contact>();    
    
        for (Integer i=0; i<2000;i++){
            Contact contact = new Contact(LastName = 'Contact ' + i, AccountId = accList[i].Id);
            conList.add(contact);
        }
        insert conList;
    }
    @isTest
    public static void afterUpdateHandler200LesContacts() {
        List<Account> accList = [SELECT Id, PushToVendor__c FROM Account LIMIT 150];

        for(Account account : accList){
            account.PushToVendor__c = 'Yes';
        }

        Test.startTest();
        update accList;
        Test.stopTest();
        
        List<Account> accUpdatedList = [SELECT Id FROM Account WHERE PushToVendor__c = 'Yes'  LIMIT 150];
        System.assert(!accUpdatedList.isEmpty());

        List<Contact> conUpdatedList = [SELECT Id, Push_Date__c FROM Contact WHERE Push_Date__c != null];
        System.assert(!conUpdatedList.isEmpty());

    }

    @isTest
    public static void afterUpdateHandlerMoreThan200Contacts() {
        List<Account> accList = [SELECT Id, PushToVendor__c FROM Account LIMIT 250];

        for(Account account : accList){
            account.PushToVendor__c = 'Yes';
        }

        Test.startTest();
        update accList;
        Test.stopTest();
        
        List<Account> accUpdatedList = [SELECT Id FROM Account WHERE PushToVendor__c = 'Yes'  LIMIT 250];
        System.assert(!accUpdatedList.isEmpty());

        List<Contact> conUpdatedList = [SELECT Id, Push_Date__c FROM Contact WHERE Push_Date__c != null];
        System.assert(!conUpdatedList.isEmpty());

    }

    @isTest
    public static void afterUpdateHandlerMoreThan1000Contacts() {
        List<Account> accList = [SELECT Id, PushToVendor__c FROM Account LIMIT 1250];

        for(Account account : accList){
            account.PushToVendor__c = 'Yes';
        }

        Test.startTest();
        update accList;
        Test.stopTest();
        
        List<Account> accUpdatedList = [SELECT Id FROM Account WHERE PushToVendor__c = 'Yes'  LIMIT 1250];
        System.assert(!accUpdatedList.isEmpty());

        List<Contact> conUpdatedList = [SELECT Id, Push_Date__c FROM Contact WHERE Push_Date__c != null];
        System.assert(!conUpdatedList.isEmpty());

    }


}
