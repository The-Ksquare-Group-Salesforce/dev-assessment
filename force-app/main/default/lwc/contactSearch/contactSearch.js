import { LightningElement, api } from 'lwc';
import getContacts from '@salesforce/apex/ContactSearchController.getContacts';
import { handlePromise } from 'c/frontEndUtils';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
export default class ContactSearch extends LightningElement {
    @api
    recordId;
    skip = 0;
    take = 10;
    searchTxt = '';
    isMoreRecords = false;
    isLoading = false;
    contacts = [];
    get columns() {
        return [
            { label: 'Name', fieldName: NAME_FIELD.fieldApiName },
            { label: 'Email', fieldName: EMAIL_FIELD.fieldApiName, type: 'email' },
            { label: 'Phone', fieldName: PHONE_FIELD.fieldApiName, type: 'phone' }
        ]
    }
    connectedCallback() {
        this.fetchContacts(true);
    }
    async fetchContacts(overwrite) {
        this.isLoading = true;
        let contacts = await handlePromise(this, getContacts, { accountId: this.recordId, skip: this.skip, take: this.take, searchTxt: this.searchTxt });
        this.isMoreRecords = contacts.length !== 0;
        if (overwrite)
            this.contacts = [...contacts];
        else
            this.contacts = [...this.contacts, ...contacts];
        this.isLoading = false;
    }
    handleLoadMoreData() {
        if(!this.isMoreRecords)
            return;
        this.skip += this.take;
        this.fetchContacts(false);
    }
    handleTxtChange(e){
        this.searchTxt = e.detail.value;
        if(this.searchTxt.length > 2 || this.searchTxt.length === 0){
            this.skip = 0;
            this.fetchContacts(true);
        }
    }
}