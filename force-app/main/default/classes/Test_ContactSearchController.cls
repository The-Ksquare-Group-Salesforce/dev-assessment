@isTest
public class Test_ContactSearchController {

	@testSetup 
    static void setup() {
		List<Account> accountList = new List<Account>();
        accountList.add(new Account(Name='accountName1'));
        accountList.add(new Account(Name='accountName2'));
    
		insert accountList;
                
        List<Contact> contactList = new List<Contact>();
        for(Integer i= 0; i < 100; i++){
            contactList.add(new Contact(Firstname= 'Test1' + i, LastName= 'Test1'+i, accountId= accountList[0].id));
        }
        
		insert contactList;
	}
    
    @isTest
    private static void testGetContacts(){
        List<Account> accounts = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'accountName1'];
       	Integer pageSize = 10;
        Integer pageNumber = 1;
        String searchTerm = 'Test1';
        Id accountId = accounts[0].id;
        
        
        List<contact> contactsAfterUpdateOfParentAccount;
        Test.startTest();
        
        	String JsonResponse = ContactSearchController.getContactList(pageSize,pageNumber,searchTerm,accountId );
                            
        Test.stopTest();
        
        ContactSearchController.ContactWrapper deserializedJson = (ContactSearchController.ContactWrapper) JSON.deserialize(JsonResponse, ContactSearchController.ContactWrapper.class);
        
        System.assertEquals(1, deserializedJson.pageNumber, 'Page number should be 1');
        System.assertEquals(10, deserializedJson.pageSize, 'Page size should be 10');
        System.assertEquals(10, deserializedJson.contacts.size(), 'There should be 10 contacts');
    }
    
    @isTest
    private static void testGetContactsNoContacts(){
        List<Account> accounts = [SELECT Id, Name, PushToVendor__c FROM Account WHERE Name = 'accountName2'];
       	Integer pageSize = 10;
        Integer pageNumber = 1;
        String searchTerm = 'Test1';
        Id accountId = accounts[0].id;
        
        
        List<contact> contactsAfterUpdateOfParentAccount;
        Test.startTest();
        
        	String JsonResponse = ContactSearchController.getContactList(pageSize,pageNumber,searchTerm,accountId );
                            
        Test.stopTest();
        
        ContactSearchController.ContactWrapper deserializedJson = (ContactSearchController.ContactWrapper) JSON.deserialize(JsonResponse, ContactSearchController.ContactWrapper.class);
        
        System.assertEquals(1, deserializedJson.pageNumber, 'Page number should be 1');
        System.assertEquals(10, deserializedJson.pageSize, 'Page size should be 10');
        System.assertEquals(0, deserializedJson.contacts.size(), 'There should be 10 contacts');
    }
    
}