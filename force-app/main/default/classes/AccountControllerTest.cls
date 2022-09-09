@isTest public class AccountControllerTest {
    @testSetup static void setup() {
        // Insert account #1 with directly related contacts
        Account acc1 = new Account(Name='Test account #1');
        insert acc1;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            contacts.add(new Contact(
                LastName = 'Test contact #' + i, 
                AccountId = acc1.Id
            ));
        }
        insert contacts;
        // Insert account #2 with directly & indirectly related contacts
        Account acc2 = new Account(Name='Test account #2');
        insert acc2;
        List<Contact> directlyContacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            directlyContacts.add(new Contact(
                LastName = 'Test contact #' + i, 
                AccountId = acc2.Id
            ));
        }
        insert directlyContacts;
        List<AccountContactRelation> accountContactRelations = new List<AccountContactRelation>();
        for (Integer i = 0; i < 3; i++) { 	// Indirectly contacts
            accountContactRelations.add(new AccountContactRelation(AccountId = acc2.Id, ContactId = contacts[i].Id));
        }
        insert accountContactRelations;
    }
    
    @isTest static void testGetDirectlyContacts() {
        Account acc = [SELECT Id, LastModifiedDate FROM Account WHERE Name = 'Test account #1' LIMIT 1];
        Test.startTest();
        	List<Contact> contacts = AccountController.getDirectOrIndirectlyContacts(acc.Id);
        Test.stopTest();
        
        System.assertEquals(3, contacts.size(), 'Contacts returned size should be 3');
    }
    
    @isTest static void testGetDirectlyOrIndirectlyContacts() {
        Account acc = [SELECT Id, LastModifiedDate FROM Account WHERE Name = 'Test account #2' LIMIT 1];
        Test.startTest();
        	List<Contact> contacts = AccountController.getDirectOrIndirectlyContacts(acc.Id);
        Test.stopTest();
        
        System.assertEquals(6, contacts.size(), 'Contacts returned size should be 6');
    }
}