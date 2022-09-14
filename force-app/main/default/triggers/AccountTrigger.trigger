trigger AccountTrigger on Account (before insert, before update, before delete,
    after insert, after update, after delete, after undelete
  ) {
      
	if(Trigger.isBefore){
		if(Trigger.isInsert){
        }   
        if(Trigger.isUpdate){
        }    
    }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
        }   
        if(Trigger.isUpdate){
      		AccountTriggerHandler.onAfterUpdateHandler(Trigger.newMap, Trigger.oldMap);
        }
    }     
}