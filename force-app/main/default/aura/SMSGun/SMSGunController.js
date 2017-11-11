({
    doInit: function (component, event, helper) {

        var action = component.get("c.getMobileNumber");
        action.setParams({
            recordId: component.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                //mobile number returned, set it in the attribute
                returnedContact = response.getReturnValue();
                component.set("v.mobileNumber", returnedContact.MobilePhone);
                console.log('mobile number is: ' + returnedContact.MobilePhone);
            } else if (state == "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    },

    sendSMS: function (component, event, helper) {

        console.log('clicked!');
    }
})