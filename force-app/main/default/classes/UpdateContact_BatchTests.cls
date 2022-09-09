@isTest public class UpdateContact_BatchTests {
    @isTest static void testUpdateContact_Batch() {
        Account acc = new Account(Name='Test account');
        insert acc;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 150; i++) {
            contacts.add(new Contact(
                LastName = 'Test contact',
                AccountId = acc.Id
            ));
        }
        insert contacts;
        Set<Id> contactIds = (new Map<Id, sObject>(contacts)).keySet();
        DateTime testDate = datetime.now();
        
        Test.startTest();
        	UpdateContacts_Batch c = new UpdateContacts_Batch(contactIds, testDate);
        	Database.executeBatch(c);
        Test.stopTest();
        List<Contact> updatedContacts = [SELECT Id, Push_Date__c, CreatedDate, LastModifiedDate FROM Contact WHERE Account.Name='Test account'];
        System.assertEquals(testDate, updatedContacts[0].Push_Date__c, 'Push_Date__c field value should be testDate');
    }
}