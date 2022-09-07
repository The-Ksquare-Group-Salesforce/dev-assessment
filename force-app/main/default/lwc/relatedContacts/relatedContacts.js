import { LightningElement, track, wire, api } from 'lwc';
import getContacts from '@salesforce/apex/AccountController.getRelatedContacts';

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text'},
    { label: 'Email', fieldName: 'Email', type: 'email'},
    { label: 'Phone', fieldName: 'Phone', type: 'text'}
  
];

export default class relatedContacts extends LightningElement {
    @api recordId;
    contacts=[];
    error;
    columns = columns;
    rowLimit =25;
    rowOffSet=0;
  
    connectedCallback() {
        this.loadData();
    }

    loadData(){
        return  getContacts({ Id: this.recordId, limitSize: this.rowLimit , offset : this.rowOffSet })
        .then(result => {
            let updatedRecords = [...this.contacts, ...result];
            this.contacts = updatedRecords;
            this.error = undefined;
            console.log(updatedRecords);
        })
        .catch(error => {
            this.error = error;
            this.accounts = undefined;
        });
    }

    loadMoreData(event) {
        const currentRecord = this.accounts;
        const { target } = event;
        target.isLoading = true;

        this.rowOffSet = this.rowOffSet + this.rowLimit;
        this.loadData()
            .then(()=> {
                target.isLoading = false;
            });   
    }


}