public with sharing class AccountTriggerHandler {
    
    private Map<Id, Account> newMap;
    private Map<Id, Account> oldMap;
    private List<Account> newList;
    private List<Account> oldList;
    private final string YES = 'Yes';
    private final string NO = 'No';
    private final integer ZERO = 0;
    private final integer LOWERLIMIT = 200;
    private final integer UPPERLIMIT = 1000;
    private final integer BATCHSIZE = 150;
    
    public AccountTriggerHandler() {
        this.newMap = (Map<Id, Account>) Trigger.newMap;
        this.oldMap = (Map<Id, Account>) Trigger.oldMap;
        this.newList = (List<Account>) Trigger.new;
        this.oldList = (List<Account>) Trigger.old;
    }
    
    public void run(){
        set<id> idSet = newMap.keySet();
        set<id> idSetToUpdate1 = new set<id>();
        set<id> idSetToUpdate2 = new set<id>();
        for(id i : idSet){
            Account oldAcc = oldMap.get(i);
            Account newAcc = newMap.get(i);
            if(oldAcc.Push_To_Vendor__c == NO && newAcc.Push_To_Vendor__c == YES){
                idSetToUpdate1.add(i);
            }else if(oldAcc.Push_To_Vendor__c == YES && newAcc.Push_To_Vendor__c == NO){
                idSetToUpdate2.add(i);
            }
        }   
        list<Contact> cons1 = [select id, Push_Date__c from Contact where Id IN (SELECT ContactId FROM AccountContactRelation WHERE AccountId in :idSetToUpdate1) WITH SECURITY_ENFORCED];
        list<Contact> cons2 = [select id, Push_Date__c from Contact where Id IN (SELECT ContactId FROM AccountContactRelation WHERE AccountId in :idSetToUpdate2) WITH SECURITY_ENFORCED];
        integer size = cons1.size() + cons2.size();
        if(size > ZERO && size <= LOWERLIMIT){
            AccountTriggerService.updateSync(cons1, cons2);
        }else if(size > LOWERLIMIT && size <= UPPERLIMIT){
            AccountTriggerService.updateAsync(idSetToUpdate1, idSetToUpdate2);
        }else if(size > UPPERLIMIT){
            map<id, dateTime> consMap = new map<id, dateTime>();
            DateTime dateT = DateTime.Now();
            for(Contact c : cons1){
                consMap.put(c.id, dateT);
            }
            for(Contact c : cons2){
                consMap.put(c.id, dateT);
            }
            UpdateContactsBatch batch = new UpdateContactsBatch(consMap);
            database.executeBatch(batch,BATCHSIZE);
        }
            
    }
}