@isTest
public class accountTriggerHandlerTest {
    static testMethod void lessThan200(){
        test.startTest();
        accountTriggerDataFactory.createCont(9,6,4);
        List<Account> getAcct = [SELECT Id FROM Account];
        Database.SaveResult[] result = Database.update(getAcct, true);
        test.stopTest();
        
        List<Contact> getContact = [SELECT Id, Push_Date__c  FROM Contact WHERE Push_Date__c != null];
        system.assertEquals(54, getContact.size());
    }
    
    static testMethod void between200And1000(){
        test.startTest();
        accountTriggerDataFactory.createCont(11,71,13);
        List<Account> getAcct = [SELECT Id FROM Account];
        Database.SaveResult[] result = Database.update(getAcct, true);
        test.stopTest();
        
        List<Contact> getContact = [SELECT Id, Push_Date__c  FROM Contact WHERE Push_Date__c != null];
        system.assertEquals(781, getContact.size());
    }
    
    static testMethod void moreThan1000(){
        test.startTest();
        accountTriggerDataFactory.createCont(9,12,4);
        List<Account> getAcct = [SELECT Id FROM Account];
        Database.SaveResult[] result = Database.update(getAcct, true);
        test.stopTest();

        List<Contact> getContact = [SELECT Id, Push_Date__c  FROM Contact WHERE Push_Date__c != null];
        system.assertEquals(108, getContact.size());
    }
}