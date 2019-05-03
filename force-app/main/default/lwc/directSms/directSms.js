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

// import the controller methods for getting userId
import sendMessage from "@salesforce/apex/messageGunController.sendMessage";
import getMobileNumber from '@salesforce/apex/messageGunController.getMobileNumber';

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
    sendMessage()
      .then(result => {
        console.log('the mobile number is: ' + JSON.stringify(this.mobileNumber));
        console.log('this was a success: ' + JSON.stringify(result));
      })
      .catch(error => {
        console.log('this was an error: ' + JSON.stringify(error));
      })
  }

  updateMessageBody(evt) {
    this.messageBody = evt.target.value;
  }
}