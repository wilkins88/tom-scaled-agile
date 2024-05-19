import { LightningElement, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import {
  APPLICATION_SCOPE,
  MessageContext,
  subscribe,
  unsubscribe
} from "lightning/messageService";
import meetupSelected from "@salesforce/messageChannel/MeetupSelected__c";

import register from "@salesforce/apex/MeetupRegistrationController.register";

const FILL_IN_REQUIRED_FIELDS_MESSAGE = "Please fill in all required fields";
const REGISTRATION_SUCCESSFUL = "Registration Complete!";

export default class RegistrationForm extends LightningElement {
  get showForm() {
    return !!this._meetupId;
  }

  @wire(MessageContext)
  _messageContext;

  _meetupId;
  _meetupSelectedSubscription;

  connectedCallback() {
    this.subscribeToMessageChannel();
  }

  disconnectedCallback() {
    this.unsubscribeToMessageChannel();
  }

  subscribeToMessageChannel() {
    if (!this._meetupSelectedSubscription) {
      this._meetupSelectedSubscription = subscribe(
        this._messageContext,
        meetupSelected,
        (message) => this.onMeetupSelect(message),
        { scope: APPLICATION_SCOPE }
      );
    }
  }

  unsubscribeToMessageChannel() {
    unsubscribe(this._meetupSelectedSubscription);
    this._meetupSelectedSubscription = null;
  }

  onMeetupSelect(message) {
    this._meetupId = message.recordId;
  }

  async onFormSubmission() {
    try {
      const inputs = Array.from(
        this.template.querySelectorAll("lightning-input")
      );
      const valid = inputs.reduce((isCurrentlyValid, input) => {
        input.reportValidity();
        return isCurrentlyValid && input.checkValidity();
      }, true);
      if (!valid) {
        return this.showToast("error", FILL_IN_REQUIRED_FIELDS_MESSAGE);
      }
      await register({
        args: inputs.reduce(
          (obj, input) => {
            obj[input.dataset.id] = input.value;
            return obj;
          },
          { meetup: this._meetupId }
        )
      });
      this.showToast("success", REGISTRATION_SUCCESSFUL);
      inputs.forEach((input) => {
        input.value = "";
      });
    } catch (e) {
      this.showToast("error", e.body?.message);
    }
  }

  showToast(variant, message) {
    this.dispatchEvent(
      new ShowToastEvent({
        variant: variant,
        message: message
      })
    );
  }
}
