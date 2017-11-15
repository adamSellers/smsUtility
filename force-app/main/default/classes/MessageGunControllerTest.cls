@isTest
private class MessageGunControllerTest {

    //next we test the Marketing Cloud SMS Service
    @isTest static void testMessage() {
        //setup Mock class
       Test.setMock(HttpCalloutMock.class, new MarketingCloudMessageMock());

        //call the Marketing Cloud Login Method from MessageGunController
        String res = MessageGunController.sendMessage('61424045767', 'messageText', 'mcKeyword', 'mcApikey', 'mcClientId', 'mcClientSecret');

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

        //now call the method
        Contact calledContact = MessageGunController.getMobileNumber(testContact.Id);
        String actual = calledContact.MobilePhone;
        System.assertEquals('61424045767', actual);

    }


    //next test is the call to get the active user id
    @isTest static void testGetUserId() {
        //TODO - implement this
        System.assert(true);

    }

    //finally, we test the insertion of the task 
    @isTest static void testCreateTask() {
        //TODO - implement this
        System.assert(true);

    }

}
