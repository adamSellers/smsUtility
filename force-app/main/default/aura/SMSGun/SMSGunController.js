({
    doInit: function (component, event) {

        var action = component.get("c.getMobileNumber");
        action.setParams({
            recordId: component.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                //mobile number returned, set it in the attribute
                var returnedContact = response.getReturnValue();
                component.set("v.mobileNumber", returnedContact.MobilePhone);
                console.log('mobile number is: ' + component.get('v.mobileNumber'));
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

    sendSMS: function (component, event) {

        //grab the message text first
        var messageText = component.get('v.messageBody');

        var action = component.get("c.sendMessage");

        action.setParams({
            mobileNumber: component.get("v.mobileNumber"),
            messageText: messageText,
            mcKeyword: component.get("v.mcKeyword"),
            mcApikey: component.get("v.mcApiKey"),
            mcClientId: component.get("v.mcClientId"),
            mcClientSecret: component.get("v.mcClientSecret")
        });

        action.setCallback(this, function (response) {

            var state = response.getState();

            if (state == "SUCCESS") {
                
                var tokenId = response.getReturnValue();

                console.log('success! Token Id is: ' + JSON.stringify(tokenId));
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    type : "success",
                    message: "SMS Id: " + tokenId + " has been delivered successfully."
                });
                toastEvent.fire();

                //clear the form to send next message
                component.set('v.messageBody', null);
                
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
    }

})