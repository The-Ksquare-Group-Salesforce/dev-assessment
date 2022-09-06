trigger AccountTrigger on Account (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        AcccountTriggerHandler.afterUpdateHandler(trigger.new);
    }
}