public class BatchableUpdateContact implements Database.Batchable<sObject>{
    Set<Id> accountsIds;
    private String query;
    public BatchableUpdateContact(Set<Id> accountIdsToUpdate) {
        this.accountsIds = accountIdsToUpdate;
        this.query = generateQuery(accountIdsToUpdate);
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(this.query);
    }

    public void execute(Database.BatchableContext context, List<Contact> scope) {
        List<Contact> contactsUpdated = new List<Contact>();
        for (Contact con : scope) {
            if (con.Account.PushToVendor__c == 'Yes') {  
                con.Push_Date__c = Datetime.now();
            } else if (con.Account.PushToVendor__c == 'No'){
                con.Push_Date__c = null;
            }
            
        }

        update contactsUpdated;
    }

    public void finish(Database.BatchableContext context) {
    }

    public static String generateQuery(Set<Id> accountsIds){
        String query = 
            'SELECT Id, Account.PushToVendor__c ' +
            'FROM Contact ' +
            'WHERE AccountId IN: accountsIds'+
            (Test.isRunningTest()?' LIMIT 150':'') ;
                
        return query;
    }
}