public with sharing class TestDataFactory {
    public static void initData(Integer accounts, Integer contacts) {
        List<Account> accs = new List<Account>();
        for(Integer i = 0; i < accounts; i++) {
            accs.add(new Account(Name = 'Test Account NO ' + i, PushToVendor__c = 'NO'));
            accs.add(new Account(Name = 'Test Account YES ' + i, PushToVendor__c = 'YES'));
        }
        
        insert accs;
        
        List<Contact> cons = new List<Contact>();
        for(Account acc : accs) {
            for(Integer i = 0; i < contacts; i++) {
            	cons.add(new Contact(LastName = 'Test Contact ' + i, AccountId = acc.Id));
            }
            
        }
        insert cons;
    }
}