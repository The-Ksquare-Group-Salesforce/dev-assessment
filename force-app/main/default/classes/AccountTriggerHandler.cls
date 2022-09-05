public with sharing class AccountTriggerHandler extends TriggerHandler {
    private List<Account> newList;
    private List<Account> oldList;
    private Map<Id,Account> newMap;
    private Map<Id,Account> oldMap;
    public AccountTriggerHandler(){
        newList = (List<Account>)Trigger.new;
        oldList = (List<Account>)Trigger.old;
        newMap = (Map<Id,Account>)Trigger.newMap;
        oldMap = (Map<Id,Account>)Trigger.oldMap;
        newList = newList == null ? new List<Account>() : newList;
        oldList = oldList == null ? new List<Account>() : oldList;
        newMap = newMap == null ? new Map<Id,Account>() : newMap;
        oldMap = oldMap == null ? new Map<Id,Account>() : oldMap;
    }
    public override void afterInsert(){
        assignPushDate();
    }
    public override void afterUpdate(){
        assignPushDate();
    }
    private void assignPushDate(){
        List<Account> toAssign = new List<Account>();
        List<Id> toAssignId = new List<Id>();
        for(Account newRecord : newList){
            Account oldRecord = oldMap.get(newRecord.Id);
            if(oldRecord != null && oldRecord.PushToVendor__c != newRecord.PushToVendor__c && String.isNotBlank(newRecord.PushToVendor__c)){
                toAssign.add(newRecord);
                toAssignId.add(newRecord.Id);
            }
            else if(oldRecord == null && String.isNotEmpty(newRecord.PushToVendor__c)){
                toAssign.add(newRecord);
                toAssignId.add(newRecord.Id);
            }
        }
        if(toAssign.isEmpty())
            return;
        Integer count = Database.countQuery('Select Count() From Contact Where AccountId In :toAssignId');
        System.debug('count:'+count);
        if(count < 200)
            PushContactHelper.updateContacts(toAssign);
        else if(count >= 200 && count < 1000)
            PushContactHelper.updateContactsFuture(toAssignId);
        else
            PushContactBatch.execute(toAssignId);
    }
}