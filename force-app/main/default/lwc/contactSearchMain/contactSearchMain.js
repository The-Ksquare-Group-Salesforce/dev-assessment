import { LightningElement, wire, api, track  } from 'lwc';
import getAccountList from '@salesforce/apex/ContactSearchController.getContactList';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
 
export default class AccountList extends NavigationMixin(LightningElement) {
    @api recordId;
    @track loader = false;
    @track error = null;
    @track pageSize = 10;
    @track pageNumber = 1;
    @track totalRecords = 0;
    @track totalPages = 0;
    @track recordEnd = 0;
    @track recordStart = 0;
    @track isPrev = true;
    @track isNext = true;
    @track contacts = [];
    @api currentSelectedContact;
    @api searchTerm;
    @api currentTimeOutId;

    constructor(){
        super();
        this.addEventListener('keypress', this.handleEnterPressed);
    }
 

    handleEnterPressed(event){
        if(event.keyCode === 13 || event.key === "Enter"){
          this.handleAccountSearchWithoutDebounce();
        }
    }


    handleContactSelected(event){
        const currentId = event.currentTarget.dataset.id;
        this.currentSelectedContact = this.contacts.filter((item)=> item.Id == currentId)[0];
    }


    handleAutomaticSearch(){
        let self = this;
        clearTimeout(this.currentTimeOutId);

        if(this.searchTerm && this.searchTerm.length == 3){
            self.getContacts();
            return;
        }  

        if (this.searchTerm == '') {
            return;
        }
        
        self.currentTimeOutId = setTimeout(() => {
            self.getContacts();
        }, 500);
        
    }


    handleAccountSearchWithoutDebounce(){
        this.getContacts();
    }


    handleAccountSearchWithDebounce(){
        let self = this;
        clearTimeout(this.currentTimeOutId);

        this.currentTimeOutId = setTimeout(() => {
            self.getContacts();
        }, 500);
    }


    handleSearchTermChange(event){
        this.searchTerm = event.target.value;
    }


    handleNext(){
        this.pageNumber = this.pageNumber+1;
        this.getContacts();
    }
 

    handlePrev(){
        this.pageNumber = this.pageNumber-1;
        this.getContacts();
    }
 

    getContacts(){

        // Prevent search with empty search term or spaces
        // If a search with empy search term is issued pressing Enter.
        if (this.searchTerm == '' || this.searchTerm.includes(' ')) {
            return;
        }

        this.loader = true; 
        getAccountList({pageSize: this.pageSize, pageNumber : this.pageNumber, searchTerm : this.searchTerm, accountId : this.recordId})
        .then(result => {
            this.loader = false;
            if(result){
                console.log(result);
                var resultData = JSON.parse(result);
                this.contacts = resultData.contacts;
                console.log(resultData.contacts);
                this.pageNumber = resultData.pageNumber;
                this.totalRecords = resultData.totalRecords;
                this.recordStart = resultData.recordStart;
                this.recordEnd = resultData.recordEnd;
                this.totalPages = Math.ceil(resultData.totalRecords / this.pageSize);
                this.isNext = (this.pageNumber == this.totalPages || this.totalPages == 0);
                this.isPrev = (this.pageNumber == 1 || this.totalRecords < this.pageSize);
                this.error = undefined;
            }
        })
        .catch(error => {
            this.error = error;
            this.loader = false;
        });
    }
 
    get isDisplayNoRecords() {
        var isDisplay = true;
        if(this.contacts){
            if(this.contacts.length == 0){
                isDisplay = true;
            }else{
                isDisplay = false;
            }
        }
        return isDisplay;
    }

    navigateToNewContactWithDefaults() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: CONTACT_OBJECT,
                actionName: 'new'
            },
            state: {
                defaultFieldValues : `AccountId=${this.recordId}`,
                nooverride: "1"
            }
        });
    }

    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}