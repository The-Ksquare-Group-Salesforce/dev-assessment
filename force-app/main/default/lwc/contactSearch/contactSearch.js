import { LightningElement, track, wire, api } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import getAccountRelatedContacts from '@salesforce/apex/ContactSearchController.getAccountRelatedContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Name', fieldName: 'Name', hideDefaultActions:true },
    { label: 'E-mail', fieldName: 'Email', type: 'email', hideDefaultActions:true },
    { label: 'Phone', fieldName: 'Phone', hideDefaultActions:true }
];

export default class ContactSearch extends LightningElement {
    @api recordId;
    @track contacts;
    columns = columns;
    isLoading = false;
    searchKey;

    contactName;
    contactRole;
    contactPhone;
    contactEmail;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
            console.debug(this.recordId);
        }
    }

    connectedCallback(){
        if(!this.isLoading){
            this.loadContacts();
        }
    }

    async loadContacts() {
        try {
            this.contacts = await getAccountRelatedContacts({accountId: this.recordId, searchKey: this.searchKey});
        } catch (error) {
            this.dispatchEvent(new ShowToastEvent({ title: 'Unhandled error', message: error, variant: 'error' }));
            console.error(error);
        }
        this.isLoading = true;
    } 

    handleEnter(event){
        if(event.keyCode === 13){
            this.handleClick();
        }
    }

    handleClick() {
        this.loadContacts();
    }
    
    handleInputChange(event) {
        this.searchKey = event.detail.value;
        if ((this.searchKey.length >= 3) || (this.searchKey.length === 0)) {
            this.loadContacts();
        }
    }
}