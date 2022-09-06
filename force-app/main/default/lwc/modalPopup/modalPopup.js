import { LightningElement, api } from "lwc";
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import ACCOUNTID_FIELD from '@salesforce/schema/Contact.AccountId';
import TITLE_FIELD from '@salesforce/schema/Contact.Title';
import PROFILE_PICTURE__C from '@salesforce/schema/Contact.Profile_Picture__c';


export default class Modal extends LightningElement {
    showModal = false;
    @api recordId;


    @api show() {
        this.showModal = true;
    }
    handleDialogClose() {
        this.showModal = false;
    }

    contactObject = CONTACT_OBJECT;
    myFields = [NAME_FIELD, EMAIL_FIELD, PHONE_FIELD, TITLE_FIELD, PROFILE_PICTURE__C];

    handleContactCreated(event) {
        event.preventDefault();
        console.log("entro al event");

        const fields = event.detail.fields;
        console.log("El valor de fields es: " + fields);
        fields.AccountId = this.recordId; // modify a field
        console.log("el field de account es " + fields.AccountId)
        this.template.querySelector('lightning-record-form').submit(fields);
    }

    handleCancel() {
        this.showModal = false;
    }

}