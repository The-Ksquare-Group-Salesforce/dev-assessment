@isTest
private class Test_AccountTriggerHandler{
        
    @isTest
    static void contactTrigger_LessThan200Test(){
        TestDataFactory.initData(2, 10);
        Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id, PushToVendor__c 
                                                       FROM Account]);
        for(Account acc:accMap.values()){
        	acc.PushToVendor__c = 'Yes';
        }
        
        List<Contact> contactList = [SELECT Id, Push_Date__c 
                                     FROM Contact 
                                     WHERE AccountId IN :accMap.keyset()];
        
        system.assertNotEquals(System.today(), contactList[0].Push_Date__c);
        test.startTest();
        update accMap.values();
        test.stopTest();
        
        contactList = [SELECT Id, Push_Date__c 
                       FROM Contact 
                       WHERE AccountId IN :accMap.keyset()];
        
        System.assertEquals(System.today(), contactList[0].Push_Date__c);
		        
    }
    
    @isTest
    static void contactTrigger_Between200_1000Test(){
        TestDataFactory.initData(2, 220);
        Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id, PushToVendor__c 
                                                       FROM Account 
                                                        WHERE PushToVendor__c = 'NO']);
        List<Contact> contactList = [SELECT Id, Push_Date__c 
                                     FROM Contact 
                                     WHERE AccountId IN :accMap.keyset()];
        
        for(Account acc : accMap.values()) {
            acc.PushToVendor__c = 'Yes';
        }
        
        system.assertNotEquals(System.today(), contactList[0].Push_Date__c);
      
        test.startTest();
        update accMap.values();
        test.stopTest();
        
        contactList = [SELECT Id, Push_Date__c 
                       FROM Contact 
                       WHERE AccountId IN :accMap.keyset()];

        System.assertEquals(System.today(), contactList[0].Push_Date__c);
    }
    
    @isTest
    static void contactTrigger_Over1000Test(){
        TestDataFactory.initData(2, 510);
        Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id, PushToVendor__c 
                                                       FROM Account 
                                                        WHERE PushToVendor__c = 'NO']);
        
        List<Contact> contactList = [SELECT Id, Push_Date__c 
                                     FROM Contact 
                                     WHERE AccountId IN :accMap.keyset()];
        
        for(Account acc : accMap.values()) {
            acc.PushToVendor__c = 'Yes';
        }
        
        system.assertNotEquals(System.today(), contactList[0].Push_Date__c);
                
        test.startTest();
        update accMap.values();
        test.stopTest();
        
        contactList = [SELECT Id, Push_Date__c 
                       FROM Contact 
                       WHERE AccountId IN :accMap.keyset()];

        System.assertEquals(System.today(), contactList[0].Push_Date__c);
    }
		        

    
    @isTest
    static void updateContactListTest_Yes(){
        TestDataFactory.initData(2, 10);

     	List<Contact> contactList = [SELECT Id, Push_Date__c, Account.PushToVendor__c
                                     FROM Contact 
                                     WHERE Account.PushToVendor__c = 'YES'];    
        
        system.assertNotEquals(System.today(), contactList[0].Push_Date__c);
        test.startTest();
        contactList = AccountTriggerHandler.updateContactList(contactList);
        test.stopTest();
        System.assertEquals(System.today(), contactList[0].Push_Date__c);
    }
    
    @isTest
    static void updateContactListTest_No(){
        TestDataFactory.initData(2, 10);

     	List<Contact> contactList = [SELECT Id, Push_Date__c, Account.PushToVendor__c
                                     FROM Contact 
                                     WHERE Account.PushToVendor__c = 'NO'];    
        for(Contact con : contactList){
            con.Push_Date__c = System.today();
        }
        update contactList;
        
        system.assertNotEquals(Null, contactList[0].Push_Date__c);
        test.startTest();
        contactList = AccountTriggerHandler.updateContactList(contactList);
        test.stopTest();
        System.assertEquals(Null, contactList[0].Push_Date__c);
    } 

}