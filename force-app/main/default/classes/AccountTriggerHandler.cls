public with sharing class AccountTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public AccountTriggerHelper helper;

    public AccountTriggerHandler(boolean triggerIsExecuting, integer triggerSize){
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new AccountTriggerHelper();
    }

    public void beforeInsert(List<Account> newRecords){
    }

    public void beforeUpdate(List<Account> oldRecords, List<Account> newRecords, Map<Id, SObject> oldRecordMap, Map<Id, SObject> newRecordMap){
    }

    public void beforeDelete(List<Account> oldRecords, Map<Id, SObject> oldRecordMap){
    }

    public void afterInsert(List<Account> newRecords, Map<Id, SObject> newRecordMap){
    }

    public void afterUpdate(List<Account> oldRecords, List<Account> newRecords, Map<Id, SObject> oldRecordMap, Map<Id, SObject> newRecordMap){
        helper.updateContactsFromAccount(newRecords);
    }

    public void afterDelete(List<Account> oldRecords, Map<Id, SObject> oldRecordMap){
    }

    public void afterUndelete(List<Account> newRecords, Map<Id, SObject> newRecordMap){
    }

}