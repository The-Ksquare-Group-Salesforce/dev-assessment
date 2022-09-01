trigger AccountTrigger on Account (after update) {

    if(Trigger.isUpdate){AccountTriggerHandler(Trigger.new);}

}