import { LightningElement, wire, api } from 'lwc';
import getRelatedContactList from '@salesforce/apex/ContactHelper.getRelatedContactList';

export default class ContactListHelper extends LightningElement {

    @api contactName;
    @api contactId;

    onClickHandler() {
        const onNameClickEvent = new CustomEvent('nameclick', { detail: this.contactId });
        this.dispatchEvent(onNameClickEvent);
    }
}
