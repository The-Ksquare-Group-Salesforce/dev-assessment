@isTest
public class ContactSearchController_TEST {
    @TestSetup
    static void makeData(){
        Account firstAccount = new Account(Name = 'First Test Account');
        insert firstAccount;

        List<Contact> firstContactList = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            Contact contact = new Contact(LastName = 'contactTest' + i, AccountId = firstAccount.Id);
            firstContactList.add(contact);
        }
        insert firstContactList;
    }

    @isTest
    public static void searchTest(){
        Account acc = [SELECT Id FROM Account WHERE Name = 'First Test Account' LIMIT 1];

        test.startTest();
        List<ContactSearchController.WrapperContact> contactList = ContactSearchController.search('contactTest',acc.Id,10,0);
        test.stopTest();

        System.assertEquals(contactList.size(), 10, 'Wrong size');
    }

    @isTest
    public static void searchSingleContactTest(){
        Account acc = [SELECT Id FROM Account WHERE Name = 'First Test Account' LIMIT 1];

        test.startTest();
        ContactSearchController.WrapperContact contactWp = ContactSearchController.searchSingleContact('contactTest',acc.Id);
        test.stopTest();

        System.assertNotEquals(contactWp,null, 'Contact must has a value');
    }
}