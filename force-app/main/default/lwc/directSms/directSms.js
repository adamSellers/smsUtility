/*
 * This component is a tool that will send an SMS from within Salesforce through your
 * Marketing Cloud SMS API. This is an upgrade from an aura componet that was previously
 * built.
 * This LWC version will utilise the V2 of the Marketing Cloud API - which is TLS compliant for
 * release on the AppExchange.
 * Adam Sellers
 * asellers@salesforce.com
 * 2nd May 2019.
 * No warranties and/or support are implied or given.
 **/

// import the necessary lwc elements
import {
    LightningElement,
    wire,
    api
} from 'lwc';
import Id from '@salesforce/user/Id';

// import the controller methods for getting userId
import sendMessage from '@salesforce/apex/messageGunController.sendMessage';
import getMobileNumber from '@salesforce/apex/messageGunController.getMobileNumber';
import insertTask from '@salesforce/apex/messageGunController.insertTask';

// import the platform services for the toast message
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';

export default class DirectSms extends LightningElement {
    /* we need to grab the user's mobile number from either
     * the case or contact object, then send the message
     * to the API method **/
    @api objectApiName;
    @api recordId;
    userId = Id;
    /* the following are taken from the component configs and are used to shoot the MC SMS**/
    @api keyword;
    @api apikey;
    @api clientId;
    @api clientSecret;

    /* store the message to be sent **/
    messageBody;

    /* use wire service to get mobile number (on a contact object) **/
    @wire(getMobileNumber, {
        recordId: '$recordId',
        sObjectName: '$objectApiName'
    })
    mobileNumber;

    /* function for sending message to customer **/
    sendSMS() {
        sendMessage({
                mobileNumber: this.mobileNumber.data.MobilePhone,
                messageText: this.messageBody,
                mcKeyword: this.keyword,
                mcApikey: this.apikey,
                mcClientId: this.clientId,
                mcClientSecret: this.clientSecret
            })
            .then(result => {
                let mcTokenId = result;
                // insert task
                // now insert the task
                insertTask({
                    description: this.messageBody +
                        ' - [Delivered by DirectSMS, message ID:' +
                        mcTokenId +
                        ']',
                    ownerId: this.userId,
                    contactId: this.mobileNumber.data.Id
                }).then(() => {
                    // show toast notification and insert task
                    const toastEvent = new ShowToastEvent({
                        title: 'Message Sent',
                        variant: 'success',
                        message: 'MC Message ID: ' + mcTokenId + ' sent successfully'
                    });
                    this.dispatchEvent(toastEvent);
                });
            })
            .catch(error => {
                this.error = error;
            });
    }

    updateMessageBody(evt) {
        this.messageBody = evt.target.value;
    }
}