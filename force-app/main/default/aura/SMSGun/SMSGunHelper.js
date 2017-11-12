({
    logCall: function (component, event, tokenId, messageText) {
        //we're going to log a call from the SMS delivered to the customer
        var callRecordEvent = $A.get("e.force:createRecord");
        var recordId = component.get("v.recordId");
        var userId = component.get("v.userId");
        console.log('contact record id is: ' + recordId);
        console.log('tokenId is: ' + tokenId);
        console.log('message to log is: ' + messageText);

        //now we setup the params of the record we'd like to create
        callRecordEvent.setParams({
            "entityApiName" : "Task",
            "defaultFieldValues" : {
                "Description": "Marketing Cloud SMS Id: " + tokenId + " sent. Message: " + messageText,
                "Priority": "Normal",
                "Status": "Completed",
                "Subject": "SMS Sent",
                "WhoId": recordId,
                "Type": "Call",
                "OwnerId" : userId
            }
        });

        callRecordEvent.fire();
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