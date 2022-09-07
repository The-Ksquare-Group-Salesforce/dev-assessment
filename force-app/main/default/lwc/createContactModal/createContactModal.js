import { LightningElement, track, api } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import Email from '@salesforce/schema/Contact.Email';
import CONTACT_OBJECT from '@salesforce/schema/Contact';

export default class CreateContactModal extends LightningElement {

  @api showPositive;
  @api showNegative;
  @api positiveButtonLabel = 'Save';
  @api negativeButtonLabel = 'Cancel';
  @api showModal;
  objectApiName = CONTACT_OBJECT;
  @api recordId;
  fields = [NAME_FIELD, Email];

  showModalBox() {
      this.showModal = true;
  }

  handleClose() {
      this.showModal = false;
  }
}
