public class secondCaseUpdate implements Database.Batchable<sObject>, Database.Stateful{    
    public List<id> ContactsIds = new List<Id>();
   public String PushToVendor='';
    public secondCaseUpdate(List<Id> contactList, String incoming){
       ContactsIds = contactList;
       PushToVendor = incoming;
    }

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([select id, Push_Date__c from Contact where accountId in: ContactsIds]);   
    }
    

    
    public void execute(Database.BatchableContext bc, List<Contact> scopeCon){
          if(PushToVendor=='No'){
            for(Contact con: scopeCon){
                con.Push_Date__c = null;
            }
        }
        
        if(PushToVendor=='Yes'){
            for(Contact con: scopeCon){
                con.Push_Date__c = Date.today();
            }
        }
        
        update scopeCon;
    }
      
 
    
    public void finish(Database.BatchableContext bc){
        
    }
}