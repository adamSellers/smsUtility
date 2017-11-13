({
    logCall: function (component, event, tokenId, messageText) {
        //we're going to log a call from the SMS delivered to the customer
        var recordId = component.get("v.recordId");
        var userId = component.get("v.userId");

        //now we setup the params of the record we'd like to create
        var action = component.get("c.insertTask");
        action.setParams({
            description: 'A text message was logged, message was: ' + messageText,
            ownerId: userId,
            contactId: recordId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                //task logged, console it!                
                console.log('task logged successfully');
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

    initMobileNumber: function (component, event) {

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

    initUserId: function (component, event) {

        var action = component.get("c.getUserId");

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                //user ID returned, set it in the attribute
                var returnedId = response.getReturnValue();
                component.set("v.userId", returnedId);
                console.log('user ID is: ' + component.get('v.userId'));
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