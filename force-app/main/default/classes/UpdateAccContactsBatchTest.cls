@isTest
public class UpdateAccContactsBatchTest {

    @testSetup
    static void setup(){
        List<Account> testAccList = new List<Account>();

        //inserting Accounts
        for(Integer i = 0; i < 50; i++){
            Account acc = new Account(Name = 'Test Account' + i);
            testAccList.add(acc);
        }
        insert testAccList; 
        
        //inserting Contancts
        List<Contact> testConList = new List<Contact>();
        for(Account acc : testAccList){
            for(Integer j = 0; j < 3; j++){
                testConList.add(new Contact (LastName = acc.Name + 'Contact' + j, AccountId = acc.Id));
            }
        }
        insert testConList;
    }

    @isTest
    public static void UpdateAccContactsBatchTestMethod() {
        Set<Id> accIds = new Set<Id>();
        List<Account> accList = [SELECT Id, PushToVendor__c FROM Account WHERE Name LIKE '%Test%'];
       
        for (Account acc : accList) {
            acc.PushTovendor__c = 'Yes';
        }

        Test.startTest();
        UpdateAccContactsBatch batch = new UpdateAccContactsBatch(accIds);
        Id contactBatch = Database.executeBatch(batch, 150);
        Test.stopTest();

        accIds = (new Map<Id,Account>(accList)).keySet();

        System.assertEquals(100, [SELECT COUNT() FROM Contact WHERE AccountId IN :accIds AND Push_Date__c != NULL]);
    }
}