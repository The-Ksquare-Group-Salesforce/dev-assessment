trigger AccountTrigger on Account (after update) {
    
    AccountTriggerHandler accountTriggerHandler = new AccountTriggerHandler();
    
    switch on Trigger.operationType
    {
        when AFTER_UPDATE
        {
           accountTriggerHandler.onAfterUpdate(trigger.new, trigger.oldMap); 
        }
    }

}