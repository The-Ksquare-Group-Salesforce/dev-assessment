@isTest
public class Test_ContactDateUpdateBatch {
    @testSetup 
    static void setup() {
		List<Account> accountList = new List<Account>();
        accountList.add(new Account(Name='accountName1'));
        accountList.add(new Account(Name='accountName2'));
        accountList.add(new Account(Name='accountName3'));
        accountList.add(new Account(Name='accountName4'));
    
		insert accountList;
                
        List<Contact> contactList = new List<Contact>();
        for(Integer i= 0; i < 50; i++){
            contactList.add(new Contact(Firstname= 'Test1' + i, LastName= 'Test1'+i, accountId= accountList[0].id));
        }
        
        for(Integer j= 0; j < 50; j++){
            contactList.add(new Contact(Firstname= 'Test1' + j, LastName= 'Test1'+j, accountId= accountList[1].id));
        }
		contactList.add(new Contact(Firstname= 'Test1', LastName= 'Test1', accountId= accountList[0].id));
        contactList.add(new Contact(Firstname= 'Test2', LastName= 'Test2', accountId= accountList[0].id));
        contactList.add(new Contact(Firstname= 'Test3', LastName= 'Test3', accountId= accountList[1].id));
        contactList.add(new Contact(Firstname= 'Test4', LastName= 'Test4', accountId= accountList[1].id));
		insert contactList;
	}
    
    @isTest
    private static void testBatchUpdatingWithDate(){
         
        Set<Id> contactIds = (new Map<Id, Contact>([SELECT Id FROM Contact])).keySet();
        Map<Id, String> contactsToUpdateDateMap = new Map<Id, String>();
        for(Id contactId :contactIds){
            contactsToUpdateDateMap.put(contactId, 'Yes');
        }
        
        Test.startTest();
        	
        	String q = 'SELECT Id, Push_Date__c FROM Contact WHERE Id IN :contactIds';
			String e = 'Contact';
			String f = 'Push_Date__c';
			Date v = Date.today();
            Id batchInstanceId2 = Database.executeBatch(new ContactDateUpdateBatch(q,e,f,v,contactsToUpdateDateMap), 150);
        
        Test.stopTest();
        
        List<Contact> contactsAfterUpdateOfParentAccount = [SELECT id, Name, Push_Date__c FROM Contact];
        
        System.debug('contactsAfterUpdateOfParentAccount');
        System.debug(contactsAfterUpdateOfParentAccount);
       
        System.assertEquals(Date.today(), contactsAfterUpdateOfParentAccount[0].Push_Date__c, 'Push_Date__c should be: null');
    }
    
    
    @isTest
    private static void testBatchUpdatingWithNull(){
         
        Set<Id> contactIds = (new Map<Id, Contact>([SELECT Id FROM Contact])).keySet();
        Map<Id, String> contactsToUpdateDateMap = new Map<Id, String>();
        for(Id contactId :contactIds){
            contactsToUpdateDateMap.put(contactId, 'No');
        }
        
        Test.startTest();
        	
        	String q = 'SELECT Id, Push_Date__c FROM Contact WHERE Id IN :contactIds';
			String e = 'Contact';
			String f = 'Push_Date__c';
			Date v = null;
            Id batchInstanceId2 = Database.executeBatch(new ContactDateUpdateBatch(q,e,f,v,contactsToUpdateDateMap), 150);
        
        Test.stopTest();
        
        List<Contact> contactsAfterUpdateOfParentAccount = [SELECT id, Name, Push_Date__c FROM Contact];
        
        System.debug('contactsAfterUpdateOfParentAccount');
        System.debug(contactsAfterUpdateOfParentAccount);
       
        System.assertEquals(null, contactsAfterUpdateOfParentAccount[0].Push_Date__c, 'Push_Date__c should be: null');
    }
}