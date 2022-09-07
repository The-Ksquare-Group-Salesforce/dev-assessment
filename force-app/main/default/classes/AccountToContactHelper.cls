public without sharing class AccountToContactHelper {
    
    
    public static void checkAccount(List<Account> accountList){
        
        List<Account> AccVendorYes = New List<Account>();
        List<Account> AccVendorNo = New List<Account>();
        
        for(Account acc: accountList){
            
            if(acc.PushToVendor__c=='Yes'){
                AccVendorYes.add(acc);
            }
            
            if(Acc.PushToVendor__c == 'No'){
                AccVendorNo.add(acc);
            }
            
        }
        
        //Check if we need to do changes and call methods
        if(AccVendorNo.size() > 0){
            List<id> contactListNo = new List<id>();
            for(Account a : AccVendorNo){
                contactListNo.add(a.id);
            }
            
            if(contactListNo.size()>0){
                
                //If 1000 <= total contact count > 200, use a one-time process to update the records. Async
                if(contactListNo.size() > 200 && contactListNo.size() < 1000){
                    firstCaseUpdate updater = new firstCaseUpdate(contactListNo,'No');
                          System.enqueueJob(updater);                                                   
                }
                
                //If total contact count > 1000, the records must be updated in smaller chunks of ideally 150 records per chunk Async
                if(contactListNo.size()>1000){
                    secondCaseUpdate myBatchObj = new secondCaseUpdate(contactListNo,'No');
                    Database.executeBatch(myBatchObj,150);
                }
                if(contactListNo.size() <= 200){updateThirdCase(contactListNo,'No');}   
            }              
        }
        
        if(AccVendorYes.size()>0){
            List<id> contactListYes = new List<id>();
            for(Account a : AccVendorYes){
                contactListYes.add(a.id);
            }
            if(contactListYes.size()>0){
                //If 1000 <= total contact count > 200, use a one-time process to update the records. Async
                if(contactListYes.size() > 200 && contactListYes.size() < 1000){
                     firstCaseUpdate updater = new firstCaseUpdate(contactListYes,'Yes');
                          System.enqueueJob(updater);
                }
                
                //If total contact count > 1000, the records must be updated in smaller chunks of ideally 150 records per chunk Async
                if(contactListYes.size()>1000){
                    secondCaseUpdate myBatchObj = new secondCaseUpdate(contactListYes,'Yes');
                    Database.executeBatch(myBatchObj,150);
                }
                if(contactListYes.size() <= 200){updateThirdCase(contactListYes,'Yes');}   
            }  
        }
        
        
        
    }
    
    
    public static void updateThirdCase(List<Id> contactList, String pushToVendor){
        List<Contact> conList = new List<Contact>([select id, Push_Date__c from contact where accountId in: contactList]);
        
        if(pushToVendor=='No'){
            for(Contact con: conList){
                con.Push_Date__c = null;
            }
        }
        
        if(pushToVendor =='Yes'){
            for(Contact con: conList){
                con.Push_Date__c= Date.today();
            }
        }
        
        update conList;
    }
}