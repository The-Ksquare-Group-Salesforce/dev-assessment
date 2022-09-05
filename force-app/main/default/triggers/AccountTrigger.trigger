trigger AccountTrigger on Account (after update) {
    AccountTriggerHandler.afterUpdateHandler(Trigger.new, Trigger.newMap);
}