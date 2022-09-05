trigger AccountTrigger on Account (
   after update
) {
    	AccountTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
}

// before insert, before update, before delete,
//    after insert, , after delete, after undelete
//