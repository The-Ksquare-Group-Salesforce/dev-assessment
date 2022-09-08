import { LightningElement, api, wire, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from "lightning/navigation";
import getContacts from '@salesforce/apex/AccountLWCController.getContacts';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import TITLE_FIELD from '@salesforce/schema/Contact.Title';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHOTO_FIELD from '@salesforce/schema/Contact.Photo__c';

export default class RelatedContacts extends NavigationMixin(LightningElement) {
   
    @track contacts;
    @track contactId;
    @track isLoading = false;

    @api recordId;

    wiredContactsResult;
    searchVal = '';
    searchVal2 = '';
    main = true;
    nameField = NAME_FIELD;
    titleField = TITLE_FIELD;
    phoneField = PHONE_FIELD;
    emailField = EMAIL_FIELD;
    photoField = PHOTO_FIELD;

    @wire (getContacts, {currentAccount: '$recordId', searchVal: '$searchVal2'})
    wiredContacts(result){
        this.wiredContactsResult = result;
        if(result.data){
            this.contacts = result.data;
            this.error = undefined;
        }else if (result.error){
            this.error = result.error;
            this.contacts = undefined;
        }
    }

    handleSearch(event) {
        this.searchVal = event.target.value;
        if(this.searchVal.length > 2){
            this.searchVal2 = this.searchVal;
        }
        else{
            this.searchVal2 = '';
        }
    }

    handleClick1(event) {
        this.closeQuickAction();
    }

    handleClick2(event) {
        this.main = false;
    }

    handleSuccess(event) {
        console.log('onsuccess event recordEditForm',event.detail.id)
    }

    handleSubmit(event) {
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
        this.isLoading = true;
        setTimeout(() => {
            refreshApex(this.wiredContactsResult);
            this.isLoading = false;
            this.main = true;
        }, 1500);
    }

    viewInfo(event) {
        this.contactId = event.target.dataset.id;
    }

    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    renderedCallback(){  
        refreshApex(this.wiredContactsResult);
    }

    viewContact(){
        console.log('hey there');
        this.navigateToRecordEditPage(this.contactId);

    }

    navigateToRecordEditPage(recordId) {
        // Opens the record modal
        // to view a particular record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });
    }
}