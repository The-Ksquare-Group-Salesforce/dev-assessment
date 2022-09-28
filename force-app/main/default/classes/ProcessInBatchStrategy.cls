public class ProcessInBatchStrategy implements ProcessingStrategy{

    private Map<Id, String> contactsToProcess;
    private Integer batchSize;
    
    
    public ProcessInBatchStrategy (Map<Id, String> contactsToProcess, Integer batchSize){
        this.contactsToProcess = contactsToProcess;
        this.batchSize = batchSize;
    }
    
    public void process(){
        if(contactsToProcess.values().size() > 0){
        	String query = 'SELECT Id, Push_Date__c FROM Contact WHERE Id IN :contactsId';
			String entity = 'Contact';
			String field = 'Push_Date__c';
			Date value = Date.today();

            if(!Test.isRunningTest()){
                 Id batchInstanceId1 = Database.executeBatch(new ContactDateUpdateBatch(query, entity, field, value,contactsToProcess), batchSize);
            }
        }
        
    }
}