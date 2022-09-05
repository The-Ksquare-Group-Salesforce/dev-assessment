@isTest
public with sharing class ContactsListControllerTest {
    @TestSetup
    static void makeData(){
   
        Account account = new Account(Name = 'Account ');
        
        insert account;
    
        List<Contact> conList = new List<Contact>();    
    
        for (Integer i=0; i<100;i++){
            Contact contact = new Contact(LastName = 'Contact ' + i, AccountId = account.Id);
            conList.add(contact);
        }
        for (Integer i=0; i<50;i++){
            Contact contact = new Contact(LastName = 'Ksquare ' + i, AccountId = account.Id);
            conList.add(contact);
        }
        insert conList;
    }

    @isTest
    public static void getContactListAllContactsTest() {
        Id currentAccount = [SELECT Id FROM Account LIMIT 1].Id;


        Test.startTest();
        List<Contact> conList = ContactsListController.getContactList(currentAccount, '');
        Test.stopTest();
        
        System.assert(!conList.isEmpty());
        System.assert(conList.size() == 150);

    }

    @isTest
    public static void getContactListSearchTermTest() {
        Id currentAccount = [SELECT Id FROM Account LIMIT 1].Id;


        Test.startTest();
        List<Contact> conList = ContactsListController.getContactList(currentAccount, 'Ksq');
        Test.stopTest();
        
        System.assert(!conList.isEmpty());
        System.assert(conList.size() == 50);

    }



}
