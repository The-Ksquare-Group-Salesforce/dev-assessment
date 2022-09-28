public class AccountServices {
    
    static final Integer SYNCRONOUS_CONTACT_QUANTITY_FLAG = 200;
    static final Integer ASYNCRONOUS_CONTACT_QUANTITY_FLAG = 1000;
    static final Integer ONE_TIME_BATCH_SIZE = 1000;
    static final Integer BATCH_SIZE = 150;
    static final String YES_CONSTANT = 'Yes';
    static final String NO_CONSTANT = 'No';

    
    public static void processChildContacsOfAccountWithVendorYesOrNo(Map<String, Account> AccountsToProcessTheirContacts) {
        Integer totalContactQuantity = 0;
        Set<Id> accountsIds= new Set<Id>();
        Map<Id, String> contactsToUpdateDateMap = new Map<Id, String>();
        
        
        for(Account acc :AccountsToProcessTheirContacts.values()){
            accountsIds.add(acc.Id);
        }
        
        
        if(accountsIds?.size() > 0){
            for (Contact contactYesOrNo : [SELECT ID, Account.PushToVendor__c FROM Contact WHERE Account.id IN :accountsIds]){
                // Counting how many contacts are in total to decide which strategy to use
                totalContactQuantity++;
                
                System.debug(contactYesOrNo);
                
                
                if(contactYesOrNo.Account.PushToVendor__c == YES_CONSTANT){
                     contactsToUpdateDateMap.put(contactYesOrNo.id, YES_CONSTANT);
                }
                
                if(contactYesOrNo.Account.PushToVendor__c == NO_CONSTANT){
                    contactsToUpdateDateMap.put(contactYesOrNo.id, NO_CONSTANT);
                }
            }
        }
        
        
        // TODO : A factory could be implemented to dynamically get strategies

       	// Process Synchronous
       	
        Savepoint sp = Database.setSavepoint();
       	
        try{
             // Process synchronous
            if(totalContactQuantity < SYNCRONOUS_CONTACT_QUANTITY_FLAG){
            
            	ProcessingStrategy strategy = new ProcessSynchronousStrategy(contactsToUpdateDateMap);
            	strategy.process();
        	}
            
            
            // Process in asynchronous one time process
    		if(totalContactQuantity > SYNCRONOUS_CONTACT_QUANTITY_FLAG && totalContactQuantity < ASYNCRONOUS_CONTACT_QUANTITY_FLAG){

        		
            	ProcessingStrategy strategy = new OneTimeProcessStrategy(contactsToUpdateDateMap, ONE_TIME_BATCH_SIZE);
				strategy.process();
    		}
            
             // Process in batchs of 150 records
    		if(totalContactQuantity >= ASYNCRONOUS_CONTACT_QUANTITY_FLAG){

            	ProcessingStrategy strategy = new ProcessInBatchStrategy(contactsToUpdateDateMap, BATCH_SIZE);
				strategy.process();
        	}
            
        }catch(Exception e){
            Database.rollback( sp );
            system.debug('Error');
            throw new AccountServicesException('Error during Account service execution');
        }
        
    }
    

    public class AccountServicesException extends Exception {}
    
}