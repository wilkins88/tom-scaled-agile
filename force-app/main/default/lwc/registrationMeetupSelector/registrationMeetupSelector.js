import { LightningElement, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { MessageContext, publish } from "lightning/messageService";
import meetupSelected from "@salesforce/messageChannel/MeetupSelected__c";
import getAvailableMeetupIdForCode from "@salesforce/apex/MeetupRegistrationController.getAvailableMeetupIdForCode";

export default class RegistrationMeetupSelector extends LightningElement {
  get showNotification() {
    return !!this._showNotification;
  }

  get errorMessage() {
    return (
      this._errorMessage ??
      "There was error with the registration page, please contact your administrator"
    );
  }

  @wire(CurrentPageReference)
  _pageRef;
  @wire(MessageContext)
  _messageContext;

  _meetupId;
  _showNotification;
  _errorMessage;

  async connectedCallback() {
    try {
      if (this._pageRef) {
        this._meetupId = await getAvailableMeetupIdForCode({
          registrationCode: this._pageRef.state.c__code
        });
        this.publishMeetupId();
      }
    } catch (e) {
      this._showNotification = true;
      this._errorMessage = e.body?.message;
    }
  }

  publishMeetupId() {
    publish(this._messageContext, meetupSelected, {
      recordId: this._meetupId
    });
  }
}
