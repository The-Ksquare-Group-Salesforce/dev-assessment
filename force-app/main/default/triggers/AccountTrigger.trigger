trigger AccountTrigger on Account (after update) {

    if(Trigger.isUpdate){AccountTriggerHandler.AccountTriggerHandlerMethod(Trigger.new);}
}