@isTest
private class MessageGunControllerTest {

    //next we test the Marketing Cloud SMS Service
    @isTest static void testMessage() {
        //setup Mock class
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MarketingCloudMessageMock());

        //call the Marketing Cloud Login Method from MessageGunController
        String res = MessageGunController.sendMessage('61424045767', 'messageText', 'mcKeyword', 'mcApikey', 'mcClientId', 'mcClientSecret');
        test.stopTest();

        System.debug('testMessage() method being executed');

        //check our response contains the values expected
        String expected = 'X2lkUG4tdTFXa3FueU9HanJCbUZCdzo3Njox';
        System.assertEquals(expected, res);

    }

    //next test is the call to get the user's mobile number as part of a contact object
    @isTest static void testMobileNumber() {
        //firstly create the contact record to test
        Contact testContact = new Contact(
            FirstName = 'Adam',
            LastName='Sellers',
            MobilePhone='61424045767',
            Email='asellers@salesforce.com'
        );

        insert testContact;

        // create a case 
        Case testCase = new Case(
            Status = 'New',
            Origin = 'Phone',
            ContactId = testContact.Id
        );

        insert testCase;

        //now call the method for the contact use case
        Contact calledContact = MessageGunController.getMobileNumber(testContact.Id, 'Contact');
        String contactActual = calledContact.MobilePhone;
        System.assertEquals('61424045767', contactActual);

        //next we call the method for the case use case
        Contact calledCaseContact = MessageGunController.getMobileNumber(testCase.Id, 'Case');
        String caseActual = calledCaseContact.MobilePhone;
        System.assertEquals('61424045767', caseActual);

    }



    //next test is the call to get the active user id
    @isTest static void testGetUserId() {
        //create the test user
        String uniqueUserName = 'anyolduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(  Alias = 'anyold', 
                            Email ='anyolduser@testorg.com',
                            EmailEncodingKey='UTF-8', 
                            LastName='User', 
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', 
                            ProfileId = p.Id,
                            TimeZoneSidKey='America/Los_Angeles',
                            UserName=uniqueUserName);

        insert u;

        System.runAs(u) {
            // The following code runs as user 'u'
            Id actual = messageGunController.getUserId();
            Id expected = u.Id;
            System.assertEquals(expected, actual);

        }

    }

    //finally, we test the insertion of the task 
    @isTest static void testCreateTask() {

        //create a user
        String uniqueUserName = 'anyolduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(  Alias = 'anyold', 
                            Email ='anyolduser@testorg.com',
                            EmailEncodingKey='UTF-8', 
                            LastName='User', 
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', 
                            ProfileId = p.Id,
                            TimeZoneSidKey='America/Los_Angeles',
                            UserName=uniqueUserName);
        insert u;

        System.debug('User details are: ' + u.LastName + u.Id);

        //create a contact
        Contact testContact = new Contact(
            FirstName = 'Adam',
            LastName='Sellers',
            MobilePhone='61424045767',
            Email='asellers@salesforce.com'
        );
        
        //create the vars
        String description = 'This is a tast';
        String ownerId = u.Id;
        String contactId = testContact.Id;
        
        //insert the task as user
        System.runAs(u) {
        // The following code runs as user 'u'
        messageGunController.insertTask(description, ownerId, contactId);
        }

        //assert that the task has been created
        Task checkTask = [SELECT Id, WhoId from Task WHERE ownerId =: ownerId];
        System.assertEquals(contactId, checkTask.whoId);
    }
}
