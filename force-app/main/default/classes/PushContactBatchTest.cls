@IsTest
public class PushContactBatchTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.insertData(10);
    }
    @IsTest
    static void testExecute(){
        List<Id> accountsId = new List<Id>();
        List<Account> accounts = new List<Account>();
        for(Account ac : [Select Id From Account]){
            ac.PushToVendor__c = Constants.ACCOUNT_PUSH_TO_VENDOR_YES;
            accounts.add(ac);
            accountsId.add(ac.Id);
        }
        update accounts;
        Test.startTest();
        PushContactBatch.execute(accountsId);
        Test.stopTest();
    }
    @IsTest
    static void testExecuteError(){
        try{
			PushContactBatch.execute(null);
            System.assert(false, 'Should throw an exception');
        }catch(PushContactBatch.PushContactBatchException pcbe){
        }
    }
}