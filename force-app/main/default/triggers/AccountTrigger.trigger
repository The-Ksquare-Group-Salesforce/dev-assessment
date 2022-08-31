trigger AccountTrigger on Account (before insert, after update) {
    AccountHandler.UpdateContacts(Trigger.new);
}