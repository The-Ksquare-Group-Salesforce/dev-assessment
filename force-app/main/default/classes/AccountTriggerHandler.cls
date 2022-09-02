public class AccountTriggerHandler {
    
    AccountTriggerHelper accountTriggerHelper = new AccountTriggerHelper();
    
    public void onAfterUpdate(List<Account> listAccount, Map<Id, Account> oldMap) {
        
        Map<Id, Account> pushedToVendorYesAccountsMap = new Map<Id, Account>();
        Map<Id, Account> pushedToVendorNoAccountsMap = new Map<Id, Account>();

        for(Account account : listAccount){

           if(oldMap != null
              && (String.isBlank(oldMap.get(account.Id).PushToVendor__c) || oldMap.get(account.Id).PushToVendor__c == AccountConstants.PUSH_TO_VENDOR_NO)
              && account.PushToVendor__c == AccountConstants.PUSH_TO_VENDOR_YES){
                  pushedToVendorYesAccountsMap.put(account.Id, account);
              } else if (oldMap != null
                         && (String.isBlank(oldMap.get(account.Id).PushToVendor__c) || oldMap.get(account.Id).PushToVendor__c == AccountConstants.PUSH_TO_VENDOR_YES)
                         && account.PushToVendor__c == AccountConstants.PUSH_TO_VENDOR_NO) {
                             pushedToVendorNoAccountsMap.put(account.Id, account );                
              }  
        }

        if (pushedToVendorYesAccountsMap.size() > 0) {            
            accountTriggerHelper.validateContactsPerAccount(pushedToVendorYesAccountsMap, DateTime.now());
        }
        if (pushedToVendorNoAccountsMap.size() > 0) {            
            accountTriggerHelper.validateContactsPerAccount(pushedToVendorNoAccountsMap, null);
        }
    } 
}