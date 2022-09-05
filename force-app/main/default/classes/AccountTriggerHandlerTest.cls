@IsTest
public class AccountTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.insertData(10);
    }
    @IsTest
    static void testAssignPushToVendorFuture(){
        testAssignPushToVendor(30);
    }
    @IsTest
    static void testAssignPushToVendorSync(){
        testAssignPushToVendor(0);
    }
    private static void testAssignPushToVendor(Integer contactsToAdd){
        List<Account> accounts = [Select Id From Account];
        if(contactsToAdd > 0)
            insert TestDataFactory.getContacts(accounts,contactsToAdd);
        for(Account ac : accounts){
            ac.PushToVendor__c = Constants.ACCOUNT_PUSH_TO_VENDOR_YES;
        }
        Test.startTest();
        update accounts;
        Test.stopTest();
        for(Contact c : [Select Id,Push_Date__c From Contact]){
            System.assert(c.Push_Date__c != null, 'Field Push Date should have a value');
        }
    }
    
}