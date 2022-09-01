trigger AccountTrigger on Account (after update) {

    if(Trigger.isUpdate){AccountTriggerHandler.AccountTriggerHandler(Trigger.new);}

}