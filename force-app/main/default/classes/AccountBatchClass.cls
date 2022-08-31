public class AccountBatchClass implements Database.Batchable<SObject> {
    
    private List<SObject> myList;
    
    public AccountBatchClass(List<SObject> lstParam){
        myList = lstParam;
    }
    
    public Iterable<SObject> start(Database.BatchableContext bc){
        return myList;
    }

    public void execute(Database.BatchableContext bc, List<Contact> scope){
        update myList;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Batch ran');
    }
}