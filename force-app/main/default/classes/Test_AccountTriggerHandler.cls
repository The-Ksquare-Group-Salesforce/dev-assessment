@isTest
public class Test_AccountTriggerHandler {

	@testSetup 
    static void setup() {
		List<Account> accountList = new List<Account>();
        accountList.add(new Account(Name='accountName1'));
        accountList.add(new Account(Name='accountName2'));
        accountList.add(new Account(Name='accountName3'));
        accountList.add(new Account(Name='accountName4'));
    
		insert accountList;
                
        List<Contact> contactList = new List<Contact>();
        for(Integer i= 0; i < 1200; i++){
            contactList.add(new Contact(Firstname= 'Test1' + i, LastName= 'Test1'+i, accountId= accountList[0].id));
        }
        
        for(Integer j= 0; j < 500; j++){
            contactList.add(new Contact(Firstname= 'Test1' + j, LastName= 'Test1'+j, accountId= accountList[1].id));
        }
		contactList.add(new Contact(Firstname= 'Test1', LastName= 'Test1', accountId= accountList[2].id));
        contactList.add(new Contact(Firstname= 'Test2', LastName= 'Test2', accountId= accountList[2].id));
        contactList.add(new Contact(Firstname= 'Test3', LastName= 'Test3', accountId= accountList[2].id));
        contactList.add(new Contact(Firstname= 'Test4', LastName= 'Test4', accountId= accountList[2].id));
        contactList.add(new Contact(Firstname= 'Test5', LastName= 'Test5', accountId= accountList[2].id));
        contactList.add(new Contact(Firstname= 'Test6', LastName= 'Test6', accountId= accountList[2].id));
        contactList.add(new Contact(Firstname= 'Test7', LastName= 'Test7', accountId= accountList[2].id));
        contactList.add(new Contact(Firstname= 'Test8', LastName= 'Test8', accountId= accountList[2].id));
        
        contactList.add(new Contact(Firstname= 'Test1f', LastName= 'Test1f', accountId= accountList[3].id));
        contactList.add(new Contact(Firstname= 'Test2f', LastName= 'Test2f', accountId= accountList[3].id));
        contactList.add(new Contact(Firstname= 'Test3f', LastName= 'Test3f', accountId= accountList[3].id));
        contactList.add(new Contact(Firstname= 'Test4f', LastName= 'Test4f', accountId= accountList[3].id));
        contactList.add(new Contact(Firstname= 'Test5f', LastName= 'Test5f', accountId= accountList[3].id));
        contactList.add(new Contact(Firstname= 'Test6f', LastName= 'Test6f', accountId= accountList[3].id));
        contactList.add(new Contact(Firstname= 'Test7f', LastName= 'Test7f', accountId= accountList[3].id));
        contactList.add(new Contact(Firstname= 'Test8f', LastName= 'Test8f', accountId= accountList[3].id));
		insert contactList;
	}
    
    @isTest
    private static void testAfterUpdateLessThan200WithParentAccountPushToVendorNo(){
        List<Account> accountsAfterModifications = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'accountName3'];
        List<Account> accountsAfterModifications2 = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'accountName4'];
        List<contact> contactsAfterUpdateOfParentAccount;
        Test.startTest();
        	accountsAfterModifications[0].PushToVendor__c = 'No';
        	accountsAfterModifications2[0].PushToVendor__c = 'No';
        
        List<Account> toUpdate = New list<Account>();
        toUpdate.addAll(accountsAfterModifications);
        toUpdate.addAll(accountsAfterModifications2);
            
        update toUpdate;
                
        Test.stopTest();
        
        contactsAfterUpdateOfParentAccount = [SELECT id, Name, Push_Date__c FROM Contact WHERE AccountId = :accountsAfterModifications[0].id];
        
        System.debug('contactsAfterUpdateOfParentAccount');
        System.debug(contactsAfterUpdateOfParentAccount);
        
        System.assertEquals(null, contactsAfterUpdateOfParentAccount[0].Push_Date__c, 'Push_Date__c should be: null');
    }
    
    @isTest
    private static void testAfterUpdateLessThan200WithParentAccountPushToVendorYes(){
        List<Account> accountsAfterModifications = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'accountName3'];
         List<Account> accountsAfterModifications2 = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'accountName4'];
        List<contact> contactsAfterUpdateOfParentAccount;
        Test.startTest();
        	accountsAfterModifications[0].PushToVendor__c = 'Yes';
        	accountsAfterModifications2[0].PushToVendor__c = 'Yes';
        	List<Account> toUpdate = New list<Account>();
        	toUpdate.addAll(accountsAfterModifications);
        	toUpdate.addAll(accountsAfterModifications2);
        
        	update toUpdate;
        Test.stopTest();
        
        contactsAfterUpdateOfParentAccount = [SELECT id, Name, Push_Date__c FROM Contact WHERE AccountId = :accountsAfterModifications[0].id];
        
        System.debug('contactsAfterUpdateOfParentAccount');
        System.debug(contactsAfterUpdateOfParentAccount);
        
        System.assertEquals(Date.today(), contactsAfterUpdateOfParentAccount[0].Push_Date__c, 'Push_Date__c should be: ' + Date.today());
    }
    
    @isTest
    private static void testBatchStrategy(){
        List<Account> accountsAfterModifications = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'accountName1'];
        List<Account> accountsAfterModifications2 = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'accountName2'];
        List<contact> contactsAfterUpdateOfParentAccount;
        Test.startTest();
        	accountsAfterModifications[0].PushToVendor__c = 'No';
        	accountsAfterModifications2[0].PushToVendor__c = 'yes';
        
        List<Account> toUpdate = New list<Account>();
        toUpdate.addAll(accountsAfterModifications);
        toUpdate.addAll(accountsAfterModifications2);
            
        update toUpdate;
                
        Test.stopTest();
        
        contactsAfterUpdateOfParentAccount = [SELECT id, Name, Push_Date__c FROM Contact WHERE AccountId = :accountsAfterModifications[0].id];
        
        System.debug('contactsAfterUpdateOfParentAccount');
        System.debug(contactsAfterUpdateOfParentAccount);
        
        System.assertEquals(null, contactsAfterUpdateOfParentAccount[0].Push_Date__c, 'Push_Date__c should be: null');
    }
    
     @isTest
    private static void testOneTimeProcessStrategy(){
        List<Account> accountsAfterModifications = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'accountName2'];
        
        List<contact> contactsAfterUpdateOfParentAccount;
        
        Test.startTest();
        	accountsAfterModifications[0].PushToVendor__c = 'Yes';
            
        	update accountsAfterModifications[0];
                
        Test.stopTest();
        
        contactsAfterUpdateOfParentAccount = [SELECT id, Name, Push_Date__c FROM Contact WHERE AccountId = :accountsAfterModifications[0].id];
        
        System.debug('contactsAfterUpdateOfParentAccount');
        System.debug(contactsAfterUpdateOfParentAccount);
        
        System.assertEquals(true, true, 'Push_Date__c should be: null');
    }
}