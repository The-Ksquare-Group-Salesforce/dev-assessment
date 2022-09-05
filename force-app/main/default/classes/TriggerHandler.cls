public virtual class TriggerHandler {
    public TriggerContext context;
    public TriggerHandler() {
        context = getContext();
    }
    public void run(){
        if(context == TriggerContext.BEFORE_INSERT)
            beforeInsert();
        else if(context == TriggerContext.BEFORE_UPDATE)
            beforeUpdate();
        else if(context == TriggerContext.BEFORE_DELETE)
            beforeDelete();
        else if(context == TriggerContext.AFTER_INSERT)
            afterInsert();
        else if(context == TriggerContext.AFTER_UPDATE)
            afterUpdate();
        else if(context == TriggerContext.AFTER_DELETE)
            afterDelete();
        else if(context == TriggerContext.AFTER_UNDELETE)
            afterUndelete();
    }
    private TriggerContext getContext(){
        if(Trigger.isExecuting){
            if(Trigger.isBefore && Trigger.isUpdate)
                return TriggerContext.BEFORE_UPDATE;
            else if(Trigger.isBefore && Trigger.isInsert)
                return TriggerContext.BEFORE_INSERT;
            else if(Trigger.isBefore && Trigger.isDelete)
                return TriggerContext.BEFORE_DELETE;
            else if(Trigger.isAfter && Trigger.isUpdate)
                return TriggerContext.AFTER_UPDATE;
            else if(Trigger.isAfter && Trigger.isInsert)
                return TriggerContext.AFTER_INSERT;
            else if(Trigger.isAfter && Trigger.isDelete)
                return TriggerContext.AFTER_DELETE;
            else if(Trigger.isAfter && Trigger.isUndelete)
                return TriggerContext.AFTER_UNDELETE;
        }
        throw new TriggerHandlerException('Unkown trigger context');
    }
    public virtual void beforeInsert(){}
    public virtual void beforeUpdate(){}
    public virtual void beforeDelete(){}
    public virtual void afterInsert(){}
    public virtual void afterUpdate(){}
    public virtual void afterDelete(){}
    public virtual void afterUndelete(){}
	public enum TriggerContext {
		BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
		AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
		AFTER_UNDELETE
	}
    public class TriggerHandlerException extends Exception{}
}