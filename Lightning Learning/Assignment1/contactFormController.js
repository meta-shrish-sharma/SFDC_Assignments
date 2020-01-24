({
    clickCreateItem: function(component, event, helper) 
    {
        var validForm = component.find("contactField").reduce(function(validSoFar, inputCmp){
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;},true);
        if(validForm)
        {
            var contact = component.get("v.newContact");
            helper.createContact(component,contact)
            
        }
    }
})