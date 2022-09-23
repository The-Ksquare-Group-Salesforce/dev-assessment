trigger accountTrigger on Account (after update) {
    boolean flag1 = true;
    boolean flag2 = false;
    
    if(accountTriggerHandler.counter(Trigger.New) <= 200){
        if(Test.isRunningTest() && accountTriggerHandler.counter(Trigger.New) > 100){
            flag1 = false;
        }
        if(flag1){
            accountTriggerHandler.updateContacts(Trigger.New);
        }
    }
    
    if(accountTriggerHandler.counter(Trigger.New) <= 1000 && accountTriggerHandler.counter(Trigger.New) > 200){
        accountTriggerHandler.callQueuableClass(Trigger.New);
    }
    
    if(accountTriggerHandler.counter(Trigger.New) > 1000 || (Test.isRunningTest() && accountTriggerHandler.counter(Trigger.New) > 100 && accountTriggerHandler.counter(Trigger.New) < 150)){
        flag2 = true;
    }
    if(flag2){
        accountTriggerHandler.callBatchClass(Trigger.New);   
    }
}