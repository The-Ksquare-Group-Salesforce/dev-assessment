@isTest
public class TestAccountController {
    @TestSetup
    static void generate(){
        Account acc = new Account(
            Name = 'Test Account');
        insert acc;

        List<Contact> conlist = new List<Contact>();
            conlist.add(new Contact(
                LastName = 'Contact Test',
                AccountId = acc.Id));
                insert conlist;
        }
    @isTest static void getContacts(){
        Account acc =  [SELECT Id, Name FROM Account WHERE Account.Name = 'Test Account'];

        List<Contact> conlist = AccountController.getRelatedContacts(acc.Id, 25, 0);
        system.assertEquals(conlist.size(), 1);
    }
}