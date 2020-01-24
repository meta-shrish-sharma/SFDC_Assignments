({
    createContact: function(component, contact) {
        var action= component.get("c.saveContact");
        action.setParams({"newContact":contact});
        action.setCallback(this,function(response)
                           {
                               var state=response.getState();
                               if(state==="SUCCESS")
                               {
                                   alert("Record created Sucessfully");
                               }
                               else
                               {
                                   alert("Record Creation Failed ");
                               }
                           });
        $A.enqueueAction(action);
    }
}
)