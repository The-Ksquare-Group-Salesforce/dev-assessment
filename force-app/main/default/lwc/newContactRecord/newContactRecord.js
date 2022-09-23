import { LightningElement, api } from 'lwc';
import conObject from '@salesforce/schema/Contact';
import conFirstName from '@salesforce/schema/Contact.FirstName';
import conLastName from '@salesforce/schema/Contact.LastName';
import conAccount from '@salesforce/schema/Contact.AccountId';
import conPhone from '@salesforce/schema/Contact.Phone';
import conEmail from '@salesforce/schema/Contact.Email';
import conTitle from '@salesforce/schema/Contact.Title';

export default class NewContactRecord extends LightningElement {
@api accountid;
firstName = '';
lastName = '';
phone= '';
emailId='';
title='';
contactChangeVal(event) {
    if(event.target.label=='First Name'){
        this.firstName = event.target.value;
    }
    if(event.target.label=='Last Name'){
        this.lastName = event.target.value;
    }
    if(event.target.label=='Phone'){
        this.phone = event.target.value;
    }
    if(event.target.label=='Email'){
        this.emailId = event.target.value;
    }
    if(event.target.label=='Title'){
        this.title = event.target.value;
    }
}
handleSaveAction(){
    const fields = {};
    fields[conFirstName.fieldApiName] = this.firstName;
    fields[conLastName.fieldApiName] = this.lastName;
    fields[conAccount.fieldApiName] = this.accountid;
    fields[conPhone.fieldApiName] = this.phone;
    fields[conEmail.fieldApiName] = this.emailId;
    fields[conTitle.fieldApiName] = this.title;
    const recordInput = { apiName: conObject.objectApiName, fields };
    this.dispatchEvent(new CustomEvent('passcontact', {detail:recordInput}));
}
}