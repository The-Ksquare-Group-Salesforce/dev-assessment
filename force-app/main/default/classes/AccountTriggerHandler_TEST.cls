@isTest
public class AccountTriggerHandler_TEST {
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

        Account secondAccount = new Account(Name = 'Second Test Account');
        insert secondAccount;

        List<Contact> secondContactList = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            Contact contact = new Contact(LastName = 'contactTest' + i, AccountId = secondAccount.Id);
            secondContactList.add(contact);
        }
        insert secondContactList;

        Account thirdAccount = new Account(Name = 'Third Test Account');
        insert thirdAccount;

        List<Contact> thirdContactList = new List<Contact>();
        for (Integer i = 0; i < 700; i++) {
            Contact contact = new Contact(LastName = 'contactTest' + i, AccountId = thirdAccount.Id);
            thirdContactList.add(contact);
        }
        insert thirdContactList;

    }

    @isTest
    public static void synchronouslyUpdate(){
        Boolean contactsUpdated = true;
        Account firstAccount = [SELECT Id FROM Account WHERE Name = 'First Test Account' LIMIT 1];
        firstAccount.PushToVendor__c = 'Yes';
        test.startTest();
        update firstAccount;
        test.stopTest();
        List<Contact> firstContactList = new List<Contact>([SELECT Id, Push_Date__c FROM Contact WHERE AccountId =: firstAccount.Id ]);
        for (Contact cont : firstContactList) {
            if (cont.Push_Date__c == null) {
                System.debug(cont.Push_Date__c);
                contactsUpdated = false;
            }
        }
        System.assertEquals(contactsUpdated, true, 'All values must be updated');
    }

    @isTest
    public static void oneTimeProcessUpdate(){
        Boolean contactsUpdated = true;
        Set<Id> accountsId = new Set<Id>();
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = 'First Test Account' OR Name = 'Second Test Account' LIMIT 2];
        for (Account acc : accounts) {
            acc.PushToVendor__c = 'Yes';
            accountsId.add(acc.Id);
        }
        test.startTest();
        update accounts;
        test.stopTest();
        List<Contact> firstContactList = new List<Contact>([SELECT Id, Push_Date__c FROM Contact WHERE AccountId IN :accountsId ]);
        for (Contact cont : firstContactList) {
            if (cont.Push_Date__c == null) {
                System.debug(cont.Push_Date__c);
                contactsUpdated = false;
            }
        }
        System.assertEquals(contactsUpdated, true, 'All values must be updated');
    }

    @isTest
    public static void asynchronouslyUpdate(){
        Boolean contactsUpdated = true;
        Set<Id> accountsId = new Set<Id>();
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = 'First Test Account' OR Name = 'Second Test Account' OR Name = 'Third Test Account' LIMIT 3];
        for (Account acc : accounts) {
            acc.PushToVendor__c = 'Yes';
            accountsId.add(acc.Id);
        }
        test.startTest();
        update accounts;
        test.stopTest();
        List<Contact> firstContactList = new List<Contact>([SELECT Id, Push_Date__c FROM Contact WHERE AccountId IN :accountsId LIMIT 150]);
        for (Contact cont : firstContactList) {
            if (cont.Push_Date__c == null) {
                System.debug(cont.Push_Date__c);
                contactsUpdated = false;
            }
        }
    }

    @isTest
    public static void negativeSynchronouslyUpdate(){
        Boolean contactsUpdated = true;
        Account firstAccount = [SELECT Id FROM Account WHERE Name = 'First Test Account' LIMIT 1];
        firstAccount.PushToVendor__c = 'No';
        test.startTest();
        update firstAccount;
        test.stopTest();
        List<Contact> firstContactList = new List<Contact>([SELECT Id, Push_Date__c FROM Contact WHERE AccountId =: firstAccount.Id ]);
        for (Contact cont : firstContactList) {
            if (cont.Push_Date__c != null) {
                System.debug(cont.Push_Date__c);
                contactsUpdated = false;
            }
        }
        System.assertEquals(contactsUpdated, true, 'All values must be updated');
    }

    @isTest
    public static void negativeOneTimeProcessUpdate(){
        Boolean contactsUpdated = true;
        Set<Id> accountsId = new Set<Id>();
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = 'First Test Account' OR Name = 'Second Test Account' LIMIT 2];
        for (Account acc : accounts) {
            acc.PushToVendor__c = 'No';
            accountsId.add(acc.Id);
        }
        test.startTest();
        update accounts;
        test.stopTest();
        List<Contact> firstContactList = new List<Contact>([SELECT Id, Push_Date__c FROM Contact WHERE AccountId IN :accountsId ]);
        for (Contact cont : firstContactList) {
            if (cont.Push_Date__c != null) {
                System.debug(cont.Push_Date__c);
                contactsUpdated = false;
            }
        }
        System.assertEquals(contactsUpdated, true, 'All values must be updated');
    }

    @isTest
    public static void negativeAsynchronouslyUpdate(){
        Boolean contactsUpdated = true;
        Set<Id> accountsId = new Set<Id>();
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = 'First Test Account' OR Name = 'Second Test Account' OR Name = 'Third Test Account' LIMIT 3];
        for (Account acc : accounts) {
            acc.PushToVendor__c = 'No';
            accountsId.add(acc.Id);
        }
        test.startTest();
        update accounts;
        test.stopTest();
        List<Contact> firstContactList = new List<Contact>([SELECT Id, Push_Date__c FROM Contact WHERE AccountId IN :accountsId LIMIT 150]);
        for (Contact cont : firstContactList) {
            if (cont.Push_Date__c != null) {
                System.debug(cont.Push_Date__c);
                contactsUpdated = false;
            }
        }
    }
}