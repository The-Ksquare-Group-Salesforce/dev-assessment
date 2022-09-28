public class OneTimeProcessStrategy implements ProcessingStrategy{

    private Map<Id, String> contactsToProcess;
    private Integer batchSize;
    
    
    public OneTimeProcessStrategy (Map<Id, String> contactsToProcess, Integer batchSize){
        this.contactsToProcess = contactsToProcess;
        this.batchSize = batchSize;
    }
    
    public void process(){
        
        if(contactsToProcess.values().size() > 0){
            System.debug('contacts in set with yes');
              // Yes ones
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