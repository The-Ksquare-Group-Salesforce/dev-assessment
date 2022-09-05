import { LightningElement, api, track } from "lwc";
import getContactData from "@salesforce/apex/Lwc_SearchContactController.getContactData";
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
{
    label: 'Name', fieldName: 'linkAccount', type: 'button',
    typeAttributes: {
        label: { fieldName: 'Name' },
        variant: "base"
    }
},
{ label: 'Phone', fieldName: 'Phone', type: 'phone' },
{ label: 'Email', fieldName: 'Email', type: 'email' }
];

export default class LwcSearchContacts extends LightningElement {
    @api recordId;
    searchKey = '';
    filter = false;
    columns = columns;
    @track selectedCon = {};
    @track displayConDetail = false;
    data = [];
    items = [];
    allItems = [];
    error;
    totalNumberOfRows = 100; // stop the infinite load after this threshold count
    recordCount = 20;
    loadMoreStatus;
    totalRecountCount = 0;
    targetDatatable; // capture the loadmore event to fetch data and stop infinite loading

    conObject = CONTACT_OBJECT;
    firstNameField = FIRSTNAME_FIELD;
    lastNameField = LASTNAME_FIELD;
    phoneField = PHONE_FIELD;
    emailField = EMAIL_FIELD;
    @track createContact = false;

    connectedCallback() {
        if (this.recordId) {
            console.log('Found recordId: ' + this.recordId);
            this.getData();
        }
    }
    getData(){
        getContactData({recordId: this.recordId, search: this.searchKey, filter: this.filter})
        .then(result => {
            result = JSON.parse(JSON.stringify(result));
            console.log('result-----'+JSON.stringify(result));
            let conObj = {};
            result.forEach(record => {
                record.linkAccount = '/' + record.Id;
                conObj = {
                    "Roles" : "",
                    "linkAccount" : '/' + record.Id,
                    "Name" : record.Name,
                    "Phone" : record.Phone,
                    "Email" : record.Email,
                    "ConImg" : record.Picture_Path__c
                }
                
                this.allItems.push(conObj);
            });

            this.totalRecountCount = result.length;
            this.items = [...this.items, ...result];
            this.data = this.items.slice(0, this.recordCount); 
            console.log('data-----'+JSON.stringify(this.data));
            this.error = undefined;
        }).catch(error => {
            this.error = error;
            this.data = undefined;
            this.items = undefined;
        });
    }
    getRecords() {
        this.recordCount = (this.recordCount > this.totalRecountCount) ? this.totalRecountCount : this.recordCount; 
        this.data = this.items.slice(0, this.recordCount); 
        this.loadMoreStatus = '';
        if (this.targetDatatable){
            this.targetDatatable.isLoading = false;
        }
    }
    // Event to handle onloadmore on lightning datatable markup
    handleLoadMore(event) {
        event.preventDefault();
        // increase the record Count by 20 on every loadmore event
        this.recordCount = this.recordCount + 20;
        //Display a spinner to signal that data is being loaded
        event.target.isLoading = true;
        //Set the onloadmore event taraget to make it visible to imperative call response to apex.
        this.targetDatatable = event.target;
        //Display "Loading" when more data is being loaded
        this.loadMoreStatus = 'Loading';
        // Get new set of records and append to this.data
        this.getRecords();
    }

    handleSearchChange(event) {
        this.searchKey = event.detail.value.toLowerCase();
        console.log('this.searchKey-----'+this.searchKey);
        let searchedTempContacts = [];
        if (this.searchKey.length > 3) {
            for (const contact of this.items) {
                console.log('contact-----'+contact);
                if (contact.Name.toLowerCase().includes(this.searchKey))
                    searchedTempContacts.push(contact);
            }
            console.log('searchedTempContacts-----'+JSON.stringify(searchedTempContacts));
            this.data = searchedTempContacts.slice(0, this.recordCount);
        }
        if (this.searchKey.length == 0)
            this.data = this.items.slice(0, this.recordCount); 
    }

    searchEnteredContacts() {
        let searchedTempContacts = [];
        if (this.searchKey.length > 3) {
            for (const contact of this.items) {
                if (contact.Name.toLowerCase().includes(this.searchKey))
                    searchedTempContacts.push(contact);
            }
            this.data = searchedTempContacts.slice(0, this.recordCount);
        }
        if (this.searchKey.length == 0)
            this.data = this.items.slice(0, this.recordCount); 
    }

    handleRowAction(event) {
        this.selectedCon = event.detail.row;
        console.log('this.selectedCon-----'+JSON.stringify(this.selectedCon));
        this.displayConDetail = true;
    }

    handleCreate(){
        this.createContact = true;
    }

    handleReset() {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }
     
    handleSuccess(event) {
        const even = new ShowToastEvent({
            title: 'Success!',
            message: 'Record created!',
            variant: 'success'
        });
        this.dispatchEvent(even);
        if(this.redirect == true){
            console.log('handleSuccess'+this.redirect);
            let creditnoteId = event.detail.id;
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId:creditnoteId,
                    objectApiName:'Contact',
                    actionName:'view'
                }
            })
        }
        this.handleReset();
    }

    handleError(event){
        const evt = new ShowToastEvent({
            title: 'Error!',
            message: event.detail.detail,
            variant: 'error',
            mode:'dismissable'
        });
        this.dispatchEvent(evt);
    }

    closeQuickAction(){             
        const closeQA = new CustomEvent('close');
        this.dispatchEvent(closeQA);    
    }

    handleCancel(){
        this.handleReset();
        this.createContact = false;
    }
         
}