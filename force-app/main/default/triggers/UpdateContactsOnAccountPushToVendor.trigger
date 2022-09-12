trigger UpdateContactsOnAccountPushToVendor on Account (after update) {
    
    if (trigger.isUpdate && trigger.isAfter) {

        UpdateContactsOnAccountHelper.PushToVendorUpdate(trigger.new);
        
    }
}