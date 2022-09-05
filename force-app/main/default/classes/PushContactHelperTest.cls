@IsTest
public class PushContactHelperTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.insertData(10);
    }
    @IsTest
    static void testUpdateContactsWithPushVendor(){
        List<Contact> contacts = [Select Id,Account.PushToVendor__c From Contact];
        for(Contact c : contacts){
            c.Account.PushToVendor__c = Constants.ACCOUNT_PUSH_TO_VENDOR_YES;
        }
        Test.startTest();
        PushContactHelper.updateContacts(contacts);
        Test.stopTest();
        for(Contact c : [Select Id,Push_Date__c From Contact]){
            System.assert(c.Push_Date__c != null, 'Contact should have a value on Push Date Field');
        }
    }
    @IsTest
    static void testUpdateContactsWithoutPushVendor(){
        List<Contact> contacts = [Select Id,Account.PushToVendor__c From Contact];
        for(Contact c : contacts){
            c.Account.PushToVendor__c = Constants.ACCOUNT_PUSH_TO_VENDOR_NO;
        }
        Test.startTest();
        PushContactHelper.updateContacts(contacts);
        Test.stopTest();
        for(Contact c : [Select Id,Push_Date__c From Contact]){
            System.assert(c.Push_Date__c == null, 'Contact should not have a value on Push Date Field');
        }
    }
    @IsTest
    static void testUpdateContactsFuture(){
        List<Account> accounts = [Select Id From Account];
        List<Id> accountsId = new List<Id>();
        for(Account ac : accounts){
            accountsId.add(ac.Id);
        }
        Test.startTest();
        PushContactHelper.updateContactsFuture(accountsId);
        Test.stopTest();
    }
}