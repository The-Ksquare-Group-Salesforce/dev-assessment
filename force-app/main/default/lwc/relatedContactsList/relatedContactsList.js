import { LightningElement, track, wire, api } from 'lwc';
import getContacts from '@salesforce/apex/AccountController.getRelatedContacts';

const columns = [
    { label: 'Name', fieldName: 'NameUrl', type: 'button', typeAttributes:{label:{fieldName:'Name'},variant:'base'}},
    { label: 'Email', fieldName: 'Email', type: 'email'},
    { label: 'Phone', fieldName: 'Phone', type: 'text'}
  
];

export default class relatedContacts extends LightningElement {
    @api recordId;
    @api contactId
    contacts=[];
    contactinitial=[];
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
            this.contactinitial = updatedRecords;
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.accounts = undefined;
        });
    }

    loadMoreData(event) {
        const currentRecord = this.contacts;
        const { target } = event;
        target.isLoading = true;

        this.rowOffSet = this.rowOffSet + this.rowLimit;
        this.loadData()
            .then(()=> {
                target.isLoading = false;
            });   
    }
    passId(event){
        const event1 = new CustomEvent('child',{
            detail:{ContactIdVal: event.detail.row.Id,
                    Imageurl: event.detail.row.Image_url__c}
        });
        console.log(event1.detail.ContactIdVal)
        this.dispatchEvent(event1);
    }
    searchKeyword(event){
        var regex = new RegExp(event.target.value,'gi')
        this.contacts = this.contactinitial.filter(
            row => regex.test(row.Name)
        );
    }


}