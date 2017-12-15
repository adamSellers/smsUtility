({
    doInit: function (component, event, helper) {

        //run two init functions, get mobile number and user ID
        helper.initMobileNumber(component, event);

        helper.initUserId(component, event);
        
    },

    sendSMS: function (component, event, helper) {

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
                //log a call with the details
                helper.logCall(component, event, tokenId, messageText);

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
    },
    onKeyPress: function(component, event, helper) {

        console.log('everything: ' + JSON.stringify(event.getParams()));
        console.log('keycode: ' + event.getParams().keyCode);

        if(event.getParams().keyCode === 13) {

            window.alert('you hit enter!');
        }

    }

})