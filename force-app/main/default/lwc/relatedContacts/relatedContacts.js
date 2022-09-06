import { LightningElement, api, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/AccountLWCController.getContacts';

import NAME_FIELD from '@salesforce/schema/Contact.Name';
import TITLE_FIELD from '@salesforce/schema/Contact.Title';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

export default class RelatedContacts extends LightningElement {
   
    @track contacts;
    @track contactId;

    @api recordId;

    searchVal = '';
    main = true;
    nameField = NAME_FIELD;
    titleField = TITLE_FIELD;
    phoneField = PHONE_FIELD;
    emailField = EMAIL_FIELD;

    @wire (getContacts, {currentAccount: '$recordId', searchVal: '$searchVal'}) wiredAccounts({data,error}){
        if (data) {
            this.contacts = data;
            console.log(data); 
        } else if (error) {
            this.contacts = undefined;
            console.log(error);
        }
    }

    handleSearch(event) {
        this.searchVal = event.target.value;
    }

    handleClick1(event) {
        console.log('a');
    }

    handleClick2(event) {
        this.main = false;
        console.log('b');
    }

    handleSuccess(event) {
        console.log('onsuccess event recordEditForm',event.detail.id)
    }

    handleSubmit(event) {
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
        this.main = true;
    }

    viewInfo(event) {
        this.contactId = event.target.dataset.id;
    }
}