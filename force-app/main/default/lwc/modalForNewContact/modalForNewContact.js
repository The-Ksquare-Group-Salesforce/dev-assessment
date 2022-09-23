import { LightningElement, api } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';

export default class ModalForNewContact extends LightningElement {
@api accountid;
showModal = false;

@api showContactModal() {
  this.showModal = true;
}
handleCloseModal() {
  this.showModal = false;
}
closeAndSave(event){
  this.handleCloseModal();
  createRecord(event.detail)
  .then(contactobj=> {
    this.contactId = contactobj.id;
    this.dispatchEvent(
      new ShowToastEvent({
        title: 'Success',
        message: 'Contact record has been created',
        variant: 'success',
      }),
    );
  })
  .catch(error => {
    this.dispatchEvent(
    console.error(error),
    new ShowToastEvent({
        title: 'Error creating record',
        message: error.body.message,
        variant: 'error',
    }),
    );
  });
  this.dispatchEvent(new CustomEvent('passrefresh'));
}
}