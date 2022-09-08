@isTest
public class AccountTriggerServicesTest {

    
    @TestSetup
    public static void data(){
        
        Account account = new Account(
        	Name = 'New Account',
            PushToVendor__c = 'No'
        );
        
        insert account;
        
        List<Contact> contactList = new List<Contact>();
        for(Integer x = 0;x<200; x++){
              Contact contact = new Contact(
                  	accountId = account.Id,
        			lastName = 'Rodriguez' + x,
                    Push_Date__c = null
        		);
             
              contactList.add(contact);
        }    
        insert contactList;
    }
    
    @isTest
    public static void getFilterAccountTest(){
        Map<Id, Account> newAccountMap = new Map<Id, Account>();
        Map<Id, Account> oldAccountMap = new Map<Id, Account>([SELECT Id, PushToVendor__c FROM Account]);
        
        for(Id accountId: oldAccountMap.keySet()){
            Account account = new Account(
                Id = accountId,
                PushToVendor__c = 'Yes'
            );
            newAccountMap.put(accountId, account);
        }
        
        Test.startTest();
        	Set<Id> accountIds = AccountTriggerServices.getFilterAccount(newAccountMap, oldAccountMap);
        Test.stopTest();
        
        System.assertEquals(1, accountIds.size(), 'The method should return 1 record.');
    }
    
    @isTest
    public static void getAllContacts(){
        Set<Id> accountIds = new Set<Id>();
        for(Account account: [SELECT Id FROM Account]){
            accountIds.add(account.Id);
        }
        
        Test.startTest();
        	List<Contact> contactList = AccountTriggerServices.getAllContacts(accountIds);
        Test.stopTest();
        
        System.assertEquals(200, contactList.size(), 'The method should return 1 record.');
    }
    
    @isTest
    public static void updatedContactRelatedOnAfterTriggerBatchTest(){
        
       	List<Contact> contactList = [SELECT Id, Push_Date__c FROM Contact LIMIT 150];
        
        Test.startTest();
        	ContactBatchable updateContact = new ContactBatchable();
        	updateContact.contactBatchList(contactList);
        	Id batchId = Database.executeBatch(updateContact);
        Test.stopTest();
        Date today = date.today();
		System.assertEquals(150, [SELECT count() FROM Contact WHERE Push_Date__c = :today]);        
        
    }

    @isTest
    public static void updateContactFutureTest(){
        
        Account account = [SELECT Id, PushToVendor__c FROM Account LIMIT 1];
        account.PushToVendor__c = 'Yes';
        
        update account;
        
        List<Contact> contactList = [SELECT Id, Push_Date__c FROM Contact];
        Set<Id> contactIds = new Set<Id>();
        
        for(Contact contact: contactList){
            contactIds.add(contact.Id);
        }
        
        Test.startTest();
        	AccountTriggerServices.updateContactFuture(contactIds);
        Test.stopTest();
        
        for(Contact contact: contactList){
            System.assertEquals(Date.today(), contact.Push_Date__c);
        }
        
    }
    
    @isTest 
    public static void getContactToUpdateTest(){
        
        Account account = [SELECT Id, PushToVendor__c FROM Account LIMIT 1];
        account.PushToVendor__c = 'Yes';
        
        update account;
        
        List<Contact> contactList = [SELECT Id, Push_Date__c, Account.PushToVendor__c FROM Contact];
        
        Test.startTest();
        	Map<Id, Contact> contactMap = AccountTriggerServices.getContactToUpdate(contactList);
        Test.stopTest();
        
        for(Id contactId: contactMap.keySet()){
            System.assertEquals(Date.today(), contactMap.get(contactId).Push_Date__c);
        }
    }    
    
    @isTest
    public static void updatedContactLessThanTwoHundred(){
        
        Map<Id, Account> oldAccountMap = new Map<Id, Account>([SELECT Id, PushToVendor__c FROM Account]);
		Map<Id, Account> newAccountMap = new Map<Id, Account>();
        List<Account> accountList = [SELECT Id, PushToVendor__c FROM Account];
		
        for(Account account: accountList){
            account.PushToVendor__c = 'Yes';
            newAccountMap.put(account.Id, account);
        }
        
        update accountList;
        
        Test.startTest();
        	List<Contact> contactList = AccountTriggerServices.updatedContactRelatedOnAfterTrigger(newAccountMap, oldAccountMap);
        Test.stopTest();
        
        for(Contact contact: contactList){
            System.assertEquals(Date.today(), contact.Push_Date__c, 'The method should return 1 record.');
        }

        
    }
    
    @isTest
    public static void updatedContactGreaterThanTwoHundred(){
        
        Account account = [SELECT Id, PushToVendor__c FROM Account LIMIT 1];
        
        Contact contact = new Contact(
            accountId = account.Id,
            lastName = 'Rodriguez Perez',
            Push_Date__c = null
        );
        
        insert contact;

        Map<Id, Account> oldAccountMap = new Map<Id, Account>([SELECT Id, PushToVendor__c FROM Account]);
		Map<Id, Account> newAccountMap = new Map<Id, Account>();
        List<Account> accountList = [SELECT Id, PushToVendor__c FROM Account];
		
        account.PushToVendor__c = 'Yes';
        newAccountMap.put(account.Id, account);
        
        update accountList;
        
        Test.startTest();
        	List<Contact> contactList = AccountTriggerServices.updatedContactRelatedOnAfterTrigger(newAccountMap, oldAccountMap);
        Test.stopTest();
        
        System.assertEquals(201, contactList.size(), 'The method should return 1001 record.');
        
    }
    
    @isTest
    public static void updatedContactGreaterThanOneThousand(){
        
        Account account = [SELECT Id, PushToVendor__c FROM Account LIMIT 1];
        
        List<Contact> newContactList = new List<Contact>();
        for(Integer x = 200;x<=1000; x++){
              Contact contact = new Contact(
                  	accountId = account.Id,
        			lastName = 'Rodriguez' + x,
                    Push_Date__c = null
        		);
             
              newContactList.add(contact);
        }    
        insert newContactList;
        
        Map<Id, Account> oldAccountMap = new Map<Id, Account>([SELECT Id, PushToVendor__c FROM Account]);
		Map<Id, Account> newAccountMap = new Map<Id, Account>();
        List<Account> accountList = [SELECT Id, PushToVendor__c FROM Account];
		
        account.PushToVendor__c = 'Yes';
        newAccountMap.put(account.Id, account);
        
        update accountList;
        
        Test.startTest();
        	List<Contact> contactList = AccountTriggerServices.updatedContactRelatedOnAfterTrigger(newAccountMap, oldAccountMap);
        Test.stopTest();
        
        System.assertEquals(1001, contactList.size(), 'The method should return 1001 record.');

        
    }
    
    
    
    
}