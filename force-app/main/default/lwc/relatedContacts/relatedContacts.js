import { LightningElement, api, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/AccountLWCController.getContacts';

export default class RelatedContacts extends LightningElement {
    @track columns = [
        {
            label: 'First Name',
            fieldName: 'FirstName'
        },
        {
            label: 'Last Name',
            fieldName: 'LastName'
        },
        {
            label: 'Email',
            fieldName: 'Email',
            type: 'email'
        },
        {
            label: 'Phone',
            fieldName: 'phone',
            type: 'phone'
        }
    ];
    @track contacts;
    @api recordId;
    searchVal = '';
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
}