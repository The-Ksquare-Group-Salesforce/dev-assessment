import { LightningElement, wire, track, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; 
import NAME_FIELD from '@salesforce/schema/User.Name';
import getContactList from '@salesforce/apex/ContactHelper.getContactList';
import { createRecord } from 'lightning/uiRecordApi';
import conObject from '@salesforce/schema/Contact';
import conFirstName from '@salesforce/schema/Contact.FirstName';
import conLastName from '@salesforce/schema/Contact.LastName';
import conPhone from '@salesforce/schema/Contact.Phone';
import conEmail from '@salesforce/schema/Contact.Email';
import conAccount from '@salesforce/schema/Contact.AccountId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Name', fieldName: 'linkContact', type: 'url',
        typeAttributes: {
            label: { fieldName: 'Name' },
            target: ''
        } 
    },
    { label: 'Email', fieldName: 'Email', type: 'email'},
    { label: 'Phone', fieldName: 'Phone', type: 'phone'}
];

export default class ContactSearchMain extends LightningElement {
    key = '';
    columns = columns;
    contactId;
    contactPhoto;
    contactName;
    contactPhone;
    contactEmail;
    contactRole;
    phone;
    emailId;
    lastName;
    firstName;
    selectedAccount;
    @api recordId;
    @track conList = [];
    @track welcomeName;
    @track welcomeError;
    @track showContactDetails = false;
    @track showContactSearchComponent = false;
    @track showContactSearchLabel = 'Show Contact Search';
    @track showCreateContactComponent = false;

    // Button to Show and Hide the Contact Search Component
    handleShowContactSearch(event){
        const showContactSearchLabel = event.target.label;
        if(showContactSearchLabel === 'Show Contact Search'){
            this.showContactSearchLabel = 'Hide Contact Search';
            this.showContactSearchComponent = true;
        } else if(showContactSearchLabel === 'Hide Contact Search'){
            this.showContactSearchLabel = 'Show Contact Search';
            this.showContactSearchComponent = false;
        }
    }

    // Get dynamic name for welcome message
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD]
    }) wireuser({
        welcomeError,
        data
    }) {
        if (data) {
            this.welcomeName = 'Hello ' + data.fields.Name.value + '!';
        } else if (welcomeError) {
            console.log("Heads Up! There was an error: " + welcomeError);
        }
    }

    // Render contact table
    connectedCallback(){
        this.selectedAccount = this.recordId;
        this.handleSearch();
    }

    updateKey(event){
        this.key = event.target.value;
        if(this.key.length >= 3){
            this.handleSearch();
        } else if(this.key.length === 0){
            this.key = '';
            this.handleSearch();
        }
    }

    handleEnter(event){
        if(event.keyCode === 13){
            this.handleSearch();
        }
    }

    handleSearch(){
        getContactList({recordId : this.recordId, searchKey : this.key})
            .then(result=>{
                result = JSON.parse(JSON.stringify(result));
                result.forEach(record => {
                    record.linkContact = this.handleSelectedColRow(record.Id);
                    // record.linkContact = '/' + record.Id;
                });
                this.conList = result;
            })
            .catch(error=>{
                console.log("Heads Up! There was an error: " + error);
            });
    }

    handleSelectedColRow(event){

        console.log("Inside handleSelectedColRow");
        // const selectedRow = this.template.querySelector('lightning-datatable');
        // const selectedRowDetails = selectedRow.getSelectedRows();
        // const parsedRowDetails = JSON.parse(JSON.stringify(selectedRowDetails));
        // if(parsedRowDetails.length === 1){
        //     this.handlePopulateContact(parsedRowDetails);
        // } else {
        //     this.showContactDetails = false;
        // }
    }

    handlePopulateContact(contDetails) {
        if(contDetails[0].Id){this.contactId = contDetails[0].Id}
        if(contDetails[0].Name){this.contactName = contDetails[0].Name}
        if(contDetails[0].Email){this.contactEmail = contDetails[0].Email}
        if(contDetails[0].Phone){this.contactPhone = contDetails[0].Phone}
        if(contDetails[0].Title){this.contactRole = contDetails[0].Title}
        contDetails[0].Contact_Photo__c ? this.contactPhoto = contDetails[0].Contact_Photo__c : this.contactPhoto = '';
        this.showContactDetails = true;
    }

    handleClose() {
        this.showContactSearchLabel = 'Show Contact Search';
        this.showContactSearchComponent = false;
    }

    handleCreateNew() {
        this.showCreateContactComponent = true;
    }

    hideContact() {
        this.showCreateContactComponent = false;
    }

    // Create new contact record
    handleAccountSelection(event){
        this.selectedAccount = event.target.value;
    }

    contactChangeVal(event) {
        if(event.target.label == 'First Name'){
            this.firstName = event.target.value;
        }
        if(event.target.label == 'Last Name'){
            this.lastName = event.target.value;
        }
        if(event.target.label == 'Phone'){
            this.phone = event.target.value;
        }
        if(event.target.label == 'Email'){
            this.emailId = event.target.value;
        }
    }

    insertContactAction(){
        const fields = {};
        fields[conFirstName.fieldApiName] = this.firstName;
        fields[conLastName.fieldApiName] = this.lastName;
        fields[conPhone.fieldApiName] = this.phone;
        fields[conEmail.fieldApiName] = this.emailId;
        fields[conAccount.fieldApiName] = this.selectedAccount;
        const recordInput = { apiName: conObject.objectApiName, fields };
        createRecord(recordInput)
            .then(result=>{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Contact record has been created',
                        variant: 'success',
                    }),
                );
                this.showCreateContactComponent = false;
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }

    handleImageClick(event) {
        const contactUrl = event.currentTarget.getAttribute("title");
        const urlToNavigate = window.location.href.substring(0, window.location.href.lastIndexOf("/r")) + '/r/Contact/' + contactUrl + '/view';
        window.open(urlToNavigate, '_blank');
    }
}