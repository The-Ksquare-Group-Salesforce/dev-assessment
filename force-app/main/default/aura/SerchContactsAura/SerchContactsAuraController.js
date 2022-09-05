({
    closeQA : function(component, event, helper) {
        var element = $A.get("e.force:closeQuickAction");
        element.fire();
    }
})