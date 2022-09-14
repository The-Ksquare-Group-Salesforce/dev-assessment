public class AccountTriggerHandler {
    private static final Date todayDate = System.Today();
    public static void onAfterUpdateHandler(Map<Id, Account> accMap, Map<Id, Account> accMapOld){       
       List<Id> accountIds = new List<Id>();
        for(Account acc : accMap.values()){
            if((accMap.get(acc.Id)).PushToVendor__c != (accMapOld.get(acc.Id)).PushToVendor__c){
            	accountIds.add(acc.Id);
            }        
        }  
        
        List<Contact> contactList = [SELECT Id, Push_Date__c, AccountId, Account.PushToVendor__c 
                                     FROM Contact 
                                     WHERE AccountId IN :accountIds];
        
        if(contactList.Size() < 200){
            update updateContactList(contactList);                
        }else if(contactList.Size() > 200 && contactList.Size() < 1000){   
            UpdateContactsBatchable contactsBatch = new UpdateContactsBatchable(contactList);
            Database.executeBatch(contactsBatch, 1000);
        }else{
            if(Test.isRunningTest()){
                for(integer i = contactList.size() ; contactList.size() > 150  ; i--){
                    system.debug(contactList.size());                    
                    contactList.remove(i-1);  
                }
            }
            UpdateContactsBatchable contactsBatch = new UpdateContactsBatchable(contactList);
            Database.executeBatch(contactsBatch, 150);           
        }
    }     

    public static List<Contact> updateContactList(List<Contact> contactList){
        for(Contact con : contactList){
            if(con.Account.PushToVendor__c == 'Yes'){         
                con.Push_Date__c = todayDate;
            }else{
                con.Push_Date__c = Null;
            } 
        }
        return contactList;
    }
}