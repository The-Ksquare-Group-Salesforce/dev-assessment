import { LightningElement,track,wire,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getContacts from '@salesforce/apex/ContactController.getContacts';

const contactColumns = [
    {label:'Name',fieldName: 'Name'},
    {label: 'Phone', fieldName: 'Phone'},
    {label: 'Email', fieldName: 'Email'}
];
export default class ContactSearch extends NavigationMixin(LightningElement) {
    @api recordId;
    
    contacts = []; // data
    selectedcontact;
    error;
    contactColumns = contactColumns;
    rowLimit = 100;
    rowOffset = 0; 
    loadMoreStatus;
    targetDatatable;
    filter = '';
   
    handleUpdateFilter(event){    
        this.filter = event.target.value;
        console.log(this.filter);
        if(this.filter.length>2){
        const inputValue = filter;
        console.log('inputValue', inputValue);
        const regex = new RegExp(`^${inputValue}`, 'i');     
        this.contacts = this.contacts.filter(row => regex.test(row.name));
        }
        if (!event.target.value) {
            this.contacts = [...this.contacts];
        }
    }
    connectedCallback() {
        this.getRecords();
    }

    getRecords() {
        getContacts({accountId: this.recordId, filter:this.filter,rowLimit:this.rowLimit,rowOffset:this.rowOffset})
            .then(result => {
            
                
                result = JSON.parse(JSON.stringify(result));
                this.contacts = [...this.contacts, ...result];
             
                this.error = undefined;
                this.loadMoreStatus = '';
                if (this.targetDatatable && this.contacts.length >= this.rowLimit) {
                    this.targetDatatable.enableInfiniteLoading = false;
                    this.loadMoreStatus = 'No more contacts to load';
                }
                if (this.targetDatatable) this.targetDatatable.isLoading = false;
                this.selectedContact = this.contacts[0];
            })
            .catch(error => {
                this.error = error;
                this.contacts = undefined;
                console.log('error : ' + JSON.stringify(this.error));
            });
    }

    handleLoadMore(event) {
        event.preventDefault();
        this.rowOffset = this.rowOffset + 10;
        event.target.isLoading = true;
        this.targetDatatable = event.target;
        this.loadMoreStatus = 'Loading Records...';
        this.getRecords();
    }

    handleNewContact() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'new'
            },
        });
    }
    // handleSearch(event){        
      
    // }       


}