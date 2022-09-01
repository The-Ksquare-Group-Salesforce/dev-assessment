trigger AccountTrigger on Account (before update) {

 if (Trigger.isBefore) {
    
    AccountTriggerHandler.beforeUpdateAccountHandler(Trigger.new);
 }

}