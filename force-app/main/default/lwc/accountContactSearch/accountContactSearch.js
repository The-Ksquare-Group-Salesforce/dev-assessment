import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAccountContacts from '@salesforce/apex/accountContactSearchController.getAccountContacts';
import getContactInfo from '@salesforce/apex/accountContactSearchController.getContactInfo';


export default class DisplayContactsOnAccountName extends NavigationMixin(LightningElement) {

    @track searchContact;
    @track currentContactValue;
    @track contacts;
    @track noContacts;
    @track contactInfoVisible = false;
    @track contactId;
    @track contactInfo;

    @wire (getAccountContacts,{contactName:'$searchContact'})
    wireContactSearch({data,error}) {
        console.log(data);
        if(data){
            this.contacts = data;
            this.error = undefined;
            this.noContacts = '';
            if(this.contacts == ''){
                this.noContacts = 'No Contact was found.';
                this.contactInfoVisible = false;
            }
            
        }else{
            this.error = error;
            this.data=undefined;
        }
    }

    @wire (getContactInfo,{contactId:'$contactId'})
    wireContactInfo({data,error}) {
        console.log(data);
        if(data){
            this.contactInfo = data;
            this.error = undefined;
            this.contactInfoVisible = true;
        }else{
            this.error = error;
            this.data=undefined;
        }
    }

    handleChangeAccName(event) {
        this.contactInfoVisible = false;
        this.currentContactValue = event.target.value
        if (this.currentContactValue.length >= 3) {
            this.searchContact = this.currentContactValue;
        } else {
            this.noContacts = '';
            this.contacts = null;
            this.contactInfoVisible = false;
        }
    }

    showContactInfo(event) {
        this.contactId = event.target.dataset.id;
    }

    navigateToContactDetailPage(event) {
        var contactId = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: contactId,
                objectApiName: 'Contact',
                actionName: 'view'
            },
        });
    }

    createNewContact() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'new'
            },
        });
    }
}