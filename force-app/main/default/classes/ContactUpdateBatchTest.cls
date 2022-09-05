@isTest
public with sharing class ContactUpdateBatchTest {
    static testmethod void ContactUpdateBatchTest() {
        // Create test accounts to be updated by batch
    List<Account> accList = new List<Account>();
    
    for (Integer i=0;i<200;i++) {
        Account account = new Account(Name = 'Account ' + i, PushToVendor__c = 'Yes');
        accList.add(account);
    }
    insert accList;

    List<Contact> conList = new List<Contact>();    

    for (Integer i=0; i<200;i++){
        Contact contact = new Contact(LastName = 'Contact ' + i, AccountId = accList[i].Id);
        conList.add(contact);
    }
    insert conList;

    Map<Id, String> lastAccountByContactsMap = new Map<Id, String>();
    for (Integer i=0;i<200;i++){
        lastAccountByContactsMap.put(conList[i].Id, accList[i].PushToVendor__c);
    }
 
    Test.startTest();
        ContactUpdateBatch batch = new ContactUpdateBatch(lastAccountByContactsMap);
        database.executeBatch(batch);
    Test.stopTest();
        // Verify contact updated
    List<Contact> conUpdatedList = [SELECT Id, Push_Date__c FROM Contact];
    System.assert(conUpdatedList[0].Push_Date__c != null);
    }
}
