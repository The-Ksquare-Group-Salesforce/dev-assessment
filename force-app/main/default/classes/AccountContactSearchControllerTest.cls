@isTest
public class AccountContactSearchControllerTest {
    
    @testSetup
    static void setupData(){
        Account lowerAccount = new Account();
        lowerAccount.Name = 'Account_Lower_Limit';
        insert lowerAccount;
        
        Contact firstContact = new Contact();
        firstContact.FirstName = 'First';
        firstContact.LastName = 'Contact';
        firstContact.Email = 'First.Contact@test.com';
        firstContact.AccountId = lowerAccount.Id;
        insert firstContact;
    }
    
    @isTest
    static void getAccountContactsTest(){
        
        List<Contact> contactResult = accountContactSearchController.getAccountContacts('First');
        test.startTest();
        
        system.assertEquals(contactResult[0].Account.Name, 'Account_Lower_Limit');
   
        test.stopTest(); 
        
    }
    
    @isTest
    static void getContactInfoTest(){
        
        Id contactId = [SELECT Id FROM Contact WHERE Email = 'First.Contact@test.com' LIMIT 1].Id;
        Contact contactResult = accountContactSearchController.getContactInfo(contactId);
        
        test.startTest();
        
        system.assertEquals(contactResult.FirstName, 'First');
   
        test.stopTest(); 
        
    }
    
}