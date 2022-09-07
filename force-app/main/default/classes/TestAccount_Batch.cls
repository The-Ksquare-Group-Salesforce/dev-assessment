@isTest
public class TestAccount_Batch {
    @TestSetup
    static void makeData(){
         List<Account> accList = new Account[]
         {
            new Account(
            Name = 'Test Account',
            PushToVendor__c = 'Yes'),
            new Account(
            Name = 'Test Account2',
            PushToVendor__c = 'No')};
        insert accList;

        List<Contact> conlist = new List<Contact>();
        for(Integer i = 0; i < 1002;i++){
            conlist.add(new Contact(
                LastName = 'Contact Test' + i,
                AccountId = accList[0].Id
            ));
        }
        for(Integer i = 0; i < 1002;i++){
            conlist.add(new Contact(
                LastName = 'Contact Test' + i,
                AccountId = accList[1].Id
            ));
        }
        insert conlist;
    }

    @isTest static void moreThan1000Yes(){
        List<Account> acc =  [SELECT Id, Name, PushToVendor__c FROM Account WHERE Account.Name = 'Test Account'];
        Test.startTest();
        AccountHandler.updateContacts(acc);
        Test.stopTest();

        List<Contact> conUp = [SELECT Id, Push_Date__c FROM Contact WHERE AccountId In :acc];

        System.assertEquals(Date.today() , conUp[0].Push_Date__c);
    }

    @isTest static void moreThan1000No(){
        List<Account> acc =  [SELECT Id, Name, PushToVendor__c FROM Account WHERE Account.Name = 'Test Account2'];
        Test.startTest();
        AccountHandler.updateContacts(acc);
        Test.stopTest();

        List<Contact> conUp = [SELECT Id, Push_Date__c FROM Contact WHERE AccountId In :acc];

        System.assertEquals(null , conUp[0].Push_Date__c);
    }
}