trigger AccounTrigger on Account (after update) {

    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            AccountTriggerServices.updatedContactRelatedOnAfterTrigger(Trigger.newMap, Trigger.oldMap);
        }
    }
	    
}