({
    doInit : function( cmp, event, helper) {
        var actionAPI = cmp.find("quickActionAPI");
        var args = {actionName: "Contact.UpdateCase"};
        actionAPI.selectAction(args).then(function(result){
            //Action selected; show data and set field values
        }).catch(function(e){
            if(e.errors){
                //If the specified action isn't found on the page, show an error message in the my component
            }
        });
    },
})
