public with sharing class AccountTriggerService {
    public static void updateSync(list<Contact> cons1, list<Contact> cons2){
        DateTime dateT = DateTime.now();
        list<Contact> consU = new list<Contact>();
        for(Contact c : cons1){
            c.Push_Date__c = dateT;
            consU.add(c);
        }
        for(Contact c : cons2){
            c.Push_Date__c = NULL;
            consU.add(c);
        }
        update consU;
    }
    
    @future
    public static void updateAsync(set<id> idSetToUpdate1, set<id> idSetToUpdate2){
        list<Contact> cons1 = [select id, Push_Date__c from Contact where Id IN (SELECT ContactId FROM AccountContactRelation WHERE AccountId in :idSetToUpdate1)];
        list<Contact> cons2 = [select id, Push_Date__c from Contact where Id IN (SELECT ContactId FROM AccountContactRelation WHERE AccountId in :idSetToUpdate2)];
		updateSync(cons1, cons2);
    }
}