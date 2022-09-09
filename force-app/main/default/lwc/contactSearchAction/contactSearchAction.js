import { LightningElement,wire,api } from 'lwc';
import getContactList from '@salesforce/apex/ContactSearchController.getContactList';
import { CloseActionScreenEvent } from 'lightning/actions';

const table_columns = [
    {label: 'Name', fieldName: 'Name', type: 'text'},
    {label: 'Email', fieldName: 'Email', type: 'link'},
    {label: 'Phone', fieldName: 'Phone', type: 'text'},

];
export default class ContactSearchAction extends LightningElement {
    @api recordId;
    @api objectApiName;
    columns = table_columns;
    error;
    contacts = [];
   
    @wire(getContactList, { accountId: '$recordId' }) contacts;
}