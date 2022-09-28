public class AccountTriggerHandler extends TriggerHandler {
  
  private Map<Id, Account> newAccounMap;
  private List<Account> newAccountList;
  private Map<Id, Account> oldAccountMap;

public AccountTriggerHandler() {
  this.newAccounMap = (Map<Id, Account>)Trigger.newMap;
  this.newAccountList = (List<Account>)Trigger.new;
  this.oldAccountMap = (Map<Id, Account>)Trigger.oldMap;
}

public override void afterUpdate() {
  	Map<String, Account> yesAndNoAccounts = new Map<String, Account>();            
  
    for(Account account : newAccountList){
  	Account oldAccount = oldAccountMap.get(account.Id);
	if(account.PushToVendor__c != oldAccount.PushToVendor__c) {
		yesAndNoAccounts.put(account.Id, account);
	}
  }
    
    AccountServices.processChildContacsOfAccountWithVendorYesOrNo(yesAndNoAccounts);

	} 
}