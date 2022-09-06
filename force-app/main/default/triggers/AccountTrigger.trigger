trigger AccountTrigger on Account (after update) {
	if (Trigger.isAfter && Trigger.isUpdate){
        AccountTriggerHandler.handleRelatedContactsChange((List<Account>)Trigger.new, (Map<Id,Account>)Trigger.oldMap);
    }
}