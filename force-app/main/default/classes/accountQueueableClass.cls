public class accountQueueableClass implements Queueable{
    
    public List<Account> acctsPassed;

    public accountQueueableClass(List<Account> acctList){
        acctsPassed = acctList;
    } 
    
    public void execute(QueueableContext param1){
        List<Contact> contToUpdate = new List<Contact>();
        
        for(Contact cont : [SELECT Id, Push_Date__c, Account.PushToVendor__c FROM Contact WHERE AccountId IN: acctsPassed AND Account.PushToVendor__c = 'Yes']){
            cont.Push_Date__c = Datetime.now();
            contToUpdate.add(cont);
        }
        
        for(Contact cont : [SELECT Id, Push_Date__c, Account.PushToVendor__c FROM Contact WHERE AccountId IN: acctsPassed AND Account.PushToVendor__c = 'No']){
            cont.Push_Date__c = null;
            contToUpdate.add(cont);
        }
        
        update contToUpdate;
    }
}