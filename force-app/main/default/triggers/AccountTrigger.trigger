trigger AccountTrigger on Account (after update) {
    AccountHandler.UpdateContacts(Trigger.new);
}