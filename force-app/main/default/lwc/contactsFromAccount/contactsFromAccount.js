import { LightningElement, wire, api, track } from 'lwc';
import getContacts from '@salesforce/apex/accountRelatedRecords.accountRelatedRecords';
import { refreshApex } from '@salesforce/apex';
 
const columns = [   
    { label: 'Name', fieldName: 'Name', type: 'button', typeAttributes: {label: {fieldName: 'Name'}, variant: 'base'}},
    { label: 'Email', fieldName: 'Email', type: 'email'},
    { label: 'Phone', fieldName: 'Phone', type: 'phone'}
];

export default class ContactsFromAccount extends LightningElement {
    @api accountid;
    @track data;
    @track columns = columns;
    @track clickOnName = false;
    @track contactId ='';
    @track contactIdToDisplay ='';
    _contactsToShow;

    @track page = 1; 
    @track items = []; 
    @track startingRecord = 1;
    @track endingRecord = 0; 
    @track pageSize = 4; 
    @track totalRecountCount = 0;
    @track totalPage = 0;
    

    @wire (getContacts, {acctId: '$accountid', contId: '$contactId'})
    contacts(contResult){
        const {data, error} = contResult;
        this._contactsToShow = contResult;
        if(data){
            console.log('Data now is::'+data.length)
            this.items = data;
            this.totalRecountCount = data.length; 
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
            this.data = this.items.slice(0,this.pageSize);
            this.endingRecord = this.pageSize;
            this.columns = columns;
            
            this.error = undefined;
        }
        if (error){
            this.error = error;
            this.data = undefined;
            console.log(this.error);
        }
    }

    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }
    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);            
        }             
    }
    displayRecordPerPage(page){
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);
        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 
        this.data = this.items.slice(this.startingRecord, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;
    }
    handleRowAction(event){
        this.contactIdToDisplay = event.detail.row.Id;
        this.clickOnName = true;
    }
    handleSearchedContact(event){
        const idFromSearch = event.detail;
        this.clickOnName = true;
        this.contactId = idFromSearch;
        this.contactIdToDisplay = idFromSearch;
        return refreshApex(this._contactsToShow);
    }
    @api doRefresh(){
        console.log('Doing refresh');
        this.clickOnName = false;
        this.contactId = '';
        return refreshApex(this._contactsToShow);
    }
}