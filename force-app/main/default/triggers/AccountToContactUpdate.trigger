trigger AccountToContactUpdate on Account (after update) {    
    if(trigger.isAfter && trigger.isupdate){    
        AccountToContactHelper.checkAccount(trigger.new);   
    }
}