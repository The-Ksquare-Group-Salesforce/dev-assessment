import { LightningElement, track, api } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import TITLE_FIELD from '@salesforce/schema/Contact.Title';
import ACCOUNT_ID from '@salesforce/schema/Contact.AccountId';
//import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateContactModal extends LightningElement {

  @api showModal;
  objectApiName = CONTACT_OBJECT;
  @api recordId;
  fields = [NAME_FIELD, EMAIL_FIELD, PHONE_FIELD, TITLE_FIELD];

  showModalBox() {
    this.showModal = true;
  }

  handleClose() {
    this.dispatchEvent(new CustomEvent('close'));
  }
  constructor() {
    super();
    this.showModal = false;
  }
  handleSubmit(event) {
    event.preventDefault(); // stop the form from submitting
    const fields = event.detail.fields;
    fields.AccountId = this.recordId; // modify a field
    this.template.querySelector('lightning-record-form').submit(fields);
  }
  handleSuccess(event) {
    const evt = new ShowToastEvent({
      title: 'Contact Created',
      message: 'Contact was created successfully',
      variant: 'success',
    });
    this.dispatchEvent(evt);
  }
}
