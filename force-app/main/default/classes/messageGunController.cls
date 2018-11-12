public with sharing class messageGunController {
    
    //this class is to be used to send SMS messages to marketing cloud
    //this is the message method.
    @AuraEnabled
    public static String sendMessage(String mobileNumber, 
                                    String messageText, 
                                    String mcKeyword, 
                                    String mcApikey,
                                    String mcClientId,
                                    String mcClientSecret) {
        
        //see below for token stuff
        String tokenId; //for returning to the component
        String auth = messageGunController.getToken(mcClientId, mcClientSecret);
        System.debug('auth token received! it is: ' + auth);
        String endPoint = 'https://www.exacttargetapis.com/sms/v1/messageContact/'+ mcApikey +'/send';

        //body is the marketing cloud payload built from two params passed in above. 
		String body = '{"mobileNumbers": ["' + mobileNumber + '"],"Override": true,"messageText": "' + messageText + '","Subscribe": true,"Resubscribe": true,"keyword": "' + mcKeyword + '"}';
        
        //build out the call to Marketing Cloud - TODO: add another parameter for the message ID in the endpoint. 
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setBody(body);
        request.setHeader('Authorization', 'Bearer ' + auth);
        request.setHeader('Content-Type', 'application/json');
        
        HttpResponse response = http.send(request);
        
        //TODO - errors.. meh!
        if(response.getStatusCode() == 202) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            tokenId = (String) results.get('tokenId');
            System.debug('token received: ' + tokenId);           
        }

        return tokenId;
        
    }
    
    public static String getToken(String mcClientId, String mcClientSecret) {

        /* This is the method that will get the auth token from MC API. 
        * This gets called every time to ensure we don't get an 'unauthorised' error 
        * in the middle of a demo ;)
        */

        String token;
        // the request body contains the clientId and clientSecret from your MC org - should be named creds one day.. 
        String body = '{"clientId": "' + mcClientId + '","clientSecret": "' + mcClientSecret + '"}';


        // setup the http request to get the token
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://auth.exacttargetapis.com/v1/requestToken');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);

        HttpResponse response = http.send(request);

        //if status 200 then grab the token and store in string variable initialised above. 
        // TODO - add some error handling here, do something if it fails i guess.. 
        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            token = (String)results.get('accessToken');

        }

        return token;
    }

    //method on init to grab customer's contact record
    @AuraEnabled
    public static Contact getMobileNumber(String recordId, String sObjectName) {

        Contact mobileRecord = new Contact();
        System.debug('sObject name is: ' + sObjectName);

        // use a switch statement!
        switch on sObjectName {
            when 'Case' {
                System.debug('Object Name is Case');
                String contactId = [SELECT Contact.Id from Case where Id =: recordId].Contact.Id;
                mobileRecord = [SELECT Id, FirstName, LastName, MobilePhone from Contact where Id =: contactId];
            }
            when 'Contact' {
                mobileRecord = [SELECT Id, FirstName, LastName, MobilePhone from Contact where Id =: recordId];
            }
        }

        //clean up the mobile phone field in this contact record
        mobileRecord.MobilePhone = mobileRecord.MobilePhone.replaceAll('[^0-9]', '');
        return mobileRecord;

    }

    //method to get the active user ID
    @AuraEnabled
    public static Id getUserId() {

        Id userId = UserInfo.getUserId();
        return userId;
    }

    //method to create the related task
    @AuraEnabled
    public static void insertTask(String description, String ownerId, String contactId ) {

        // check isCreateable at all Field Levels and object level
        if (Schema.SObjectType.Task.isCreateable() &&
            Schema.sObjectType.Task.fields.Description.isCreateable() && 
            Schema.sObjectType.Task.fields.Priority.isCreateable() &&
            Schema.sObjectType.Task.fields.Status.isCreateable() &&
            Schema.sObjectType.Task.fields.Subject.isCreateable() &&
            Schema.sObjectType.Task.fields.OwnerId.isCreateable() &&
            Schema.sObjectType.Task.fields.TaskSubType.isCreateable() &&
            Schema.sObjectType.Task.fields.WhoId.isCreateable() &&
            Schema.sObjectType.Task.fields.ActivityDate.isCreateable()) {

            //create the task record
            Task smsCreated = new Task(
                Description = description,
                Priority = 'Normal',
                Status = 'Complete',
                Subject = 'SMS Logged',
                OwnerId = ownerId,
                TaskSubType = 'Call',
                WhoId = contactId,
                ActivityDate = Date.today()
            );
            insert smsCreated;
        } else {
            // throw an exception to the user that they don't have access
            NoAccessException noAccess = new NoAccessException();
            noAccess.setMessage('User doesn\'t have create task permissions');
            throw noAccess;
        } 
        
    }

}