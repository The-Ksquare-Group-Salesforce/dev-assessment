@isTest
public with sharing class Test_ContactBatch {
    public static testMethod void testBatch(){
        List<Contact> cons=new List<Contact>();
        Account acc =new Account(Name='Test 1');
        insert acc;
        Account acc1 = [Select Id FROM Account WHERE Name='Test 1' LIMIT 1];
            for(integer i = 0 ; i < 100 ; i++ ){
                cons.add(new Contact(LastName='Test', AccountId=acc1.Id, Push_Date__c= null));
            }
        insert cons;

        List<Contact> contactsToUpdate= [SELECT Id, Push_Date__c FROM Contact WHERE AccountId =: acc1.Id];
        for(Contact con :contactsToUpdate){
            con.Push_Date__c=datetime.now();
        }
        
        Test.startTest();
        ID batchProcess= Database.executeBatch(new ContactBatch(contactsToUpdate));
        Test.stopTest();
        System.assertEquals(100, [SELECT Id FROM Contact WHERE Push_Date__c !=null].size());
}
}
