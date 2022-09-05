@IsTest
public class ContactSearchControllerTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.insertData(10);
    }
    @IsTest
    static void testGetContactsSuccess(){
        Account ac = [Select Id From Account Limit 1];
        List<Contact> contacts = [Select Id From Contact Where AccountId = :ac.Id];
        Test.startTest();
        List<Contact> result = ContactSearchController.getContacts(ac.Id, '', 0, 1000);
        Test.stopTest();
        System.assertEquals(contacts.size(), result.size(), 'Should return all of the contacts from the account');
    }
    @IsTest
    static void testGetContactsEmpty(){
        Account ac = [Select Id From Account Limit 1];
        Test.startTest();
        List<Contact> result = ContactSearchController.getContacts(ac.Id, 'Return an empty list', 0, 1000);
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Should return an empty list');
    }
}