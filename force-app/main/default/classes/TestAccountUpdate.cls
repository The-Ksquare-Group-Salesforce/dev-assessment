@isTest
public class TestAccountUpdate {
    @isTest static void updateLess200AccountToYes(){
        Account acc = new Account(
            Name = 'Test Account');
        insert acc;

        List<Contact> conlist = new List<Contact>();
        for(Integer i = 0; i < 160;i++){
            conlist.add(new Contact(
                LastName = 'Contact Test' + i,
                AccountId = acc.Id
            ));
        }
        insert conlist;
        
        acc.PushToVendor__c = 'Yes';
        update acc;

        List<Contact> conUp = [SELECT Id, Push_Date__c FROM Contact WHERE AccountId = :acc.Id];

        System.assertEquals(Date.today() , conUp[0].Push_Date__c);

    }

    @isTest static void updateLess200AccountToNo(){
        Account acc = new Account(
            Name = 'Test Account',
            PushToVendor__c = 'Yes');
        insert acc;

        List<Contact> conlist = new List<Contact>();
        for(Integer i = 0; i < 160;i++){
            conlist.add(new Contact(
                LastName = 'Contact Test' + i,
                AccountId = acc.Id,
                Push_Date__c = Date.Today()
            ));
        }
        insert conlist;
        
        acc.PushToVendor__c = 'No';
        update acc;

        List<Contact> conUp = [SELECT Id, Push_Date__c FROM Contact WHERE AccountId = :acc.Id];

        System.assertEquals(null , conUp[0].Push_Date__c);

    }
}