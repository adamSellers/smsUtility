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
    public static Contact getMobileNumber(String recordId) {

        Contact mobileNumber = [SELECT Id, FirstName, LastName, MobilePhone from Contact where Id =: recordId];

        //clean up the mobile phone field in this contact record
        mobileNumber.MobilePhone = mobileNumber.MobilePhone.replaceAll('[^0-9]', '');
        return mobileNumber;

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
    }

}