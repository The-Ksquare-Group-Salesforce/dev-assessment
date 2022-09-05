import { LightningElement} from 'lwc';
import getContacts from '@salesforce/apex/contactSearchController.getAllContacts';
import getSearchContacts from '@salesforce/apex/contactSearchController.getSearchContacts';
import USER_IMAGE from '@salesforce/resourceUrl/UserImage';
import { CloseActionScreenEvent } from 'lightning/actions';
import { New } from 'lightning/actions';

const columns = [
    {label: 'Name', fieldName: 'Name', type: 'text'},
    {label: 'Email', fieldName: 'Email', type: 'text'},
    {label: 'Phone', fieldName: 'Phone', type: 'text'}
];

export default class ContactSearch extends LightningElement {

    contacts=[];
    currentContact={};
    limit = 10;
    offSet = 0;
    error;
    columns = columns;
    userImage = USER_IMAGE;
    isLoading = false;
    search = '';

    connectedCallback(){
        this.loadContactData();
    }

    loadFirstContact(){
        const contactData = this.contacts.filter(function(currItem, index, actualArr){
            return index == 0
        })  

        this.currentContact = {
            Name: contactData[0].Name,
            Email: contactData[0].Email,
            Phone: contactData[0].Phone,
            Title: contactData[0].Title
        }

    }

    loadContactData(){
        return getContacts({limitSize: this.limit, offset: this.offSet}).then(result => {
            let updateRecords = [...this.contacts, ...result];
            this.contacts = updateRecords;
            this.error = undefined;
            this.loadFirstContact();
        }).catch(error => {
            this.error = error;
            this.contacts = undefined;
        });
    }


    loadMoreContactData(event){
        const { target } = event;
        target.isLoading = true;

        this.offSet = this.offSet + this.limit;
        this.loadContactData().then(() => {
            target.isLoading = false;
        })
    }

    getContactData(event){

        let contactId = event.currentTarget.dataset.id;

        const contactData = this.contacts.filter(function(currItem, index, actualArr){
            return currItem.Id == contactId
        })

        this.currentContact = {
            Name: contactData[0].Name,
            Email: contactData[0].Email,
            Phone: contactData[0].Phone,
            Title: contactData[0].Title
        }
    }

    handleSearch(){
        getContactBySearch(this.search);
    }

    getContactBySearch(searchText){
        return getSearchContacts({search: searchText}).then(result => {
            let searchRecords = result;
            this.contacts = searchRecords;
            this.error = undefined;
            this.isLoading = false;
            this.loadFirstContact();
        }).catch(error => {
            this.isLoading = false;
            this.error = error;
            this.contacts = undefined;
        });
    }

    handleOnSearch(event){
        this.isLoading = true;

        this.search = event.target.value;
        const count = this.search.split("");
        
        let isCount = count.length >= 3 ? true: false;

        if(isCount || count.length == 0){
            this.getContactBySearch(this.search);
        }
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}