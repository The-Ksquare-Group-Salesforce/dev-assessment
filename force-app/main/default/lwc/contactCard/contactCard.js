import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import CONTACT_OBJECT from '@salesforce/schema/Contact';

export default class ContactCard extends  NavigationMixin(LightningElement) {
    @api contact;
    
    viewRecord() {
        const id = this.contact.Id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                "recordId": id,
                "objectApiName": CONTACT_OBJECT,
                "actionName": "view"
            },
        });
    }

    get mailToAddress(){
        if (this.contact) {
            return `mailto: ${this.contact.Email}`
        }
        return '';
    }

    get isContactUndefined(){
        if (this.contact) {
            return true;
        }
        return false;
    }

    get isContactUrlImagePopulated(){
        const imageURL = this.contact.Contact_Image__c;
        if (imageURL && imageURL.length != 0) {
            return true;
        }
        return false;
    }

}