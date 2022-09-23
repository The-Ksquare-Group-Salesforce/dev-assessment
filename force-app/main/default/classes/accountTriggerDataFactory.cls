@isTest
public class accountTriggerDataFactory {
    
    public static List<Contact> createCont(Integer numCont, Integer acctYes, Integer acctNo){
        List<Account> acct = accountTriggerDataFactory.createAcct(acctYes, acctNo);
        List<Contact> contCreated = new List<Contact>();
        
        for(Account a : acct){
            for (Integer i = 1; i <= numCont; i++){
                Contact c = new Contact(LastName = 'testCont' + i, AccountId = a.Id);
                contCreated.add(c);
            }
        }
        
        insert contCreated;
        return contCreated;
    }
    
    public static List<Account> createAcct(Integer acctYes, Integer acctNo){
        List<Account> acctCreated = new List<Account>();
        
        for (Integer i = 1; i <= acctYes; i++){
            Account a = new Account(Name = 'testAcct' + i,PushToVendor__c = 'Yes');
            acctCreated.add(a);
        }
        
        for (Integer i = 1; i <= acctNo; i++){
            Account a = new Account(Name = 'testAcct' + i, PushToVendor__c = 'No');
            acctCreated.add(a);
        }
        
        insert acctCreated;
        return acctCreated;
    }
    
    public static List<Account> createAccWithCont(Integer numAcct, Integer numCont){
        List<Account> accts = new List<Account>();
        for(Integer i = 0; i < numAcct; i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;
        
        List<Contact> conts = new List<Contact>();
        for (Integer j =0 ; j < numAcct; j++) {
            Account acct = accts[j];
            for (Integer k = 0; k < numCont; k++) {
                conts.add(new Contact(LastName='Contact' + k, AccountId=acct.Id));
            }
        }
        insert conts;
        return accts;
    }
    
}