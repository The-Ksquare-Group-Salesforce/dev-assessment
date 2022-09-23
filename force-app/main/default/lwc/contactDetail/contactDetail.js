import { LightningElement, wire, api, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getPhotoId from '@salesforce/apex/accountRelatedRecords.getPhotoId';
import ANONYMOUS from '@salesforce/resourceUrl/noPic';

const FIELDS = [
    'Contact.Name',
    'Contact.Title',
    'Contact.Phone',
    'Contact.Email',
];


export default class ContactDetail extends LightningElement {
    @api contactid;
    @track photoURL;
    @track contURL;
    @track items = [];
    emptyPhoto = ANONYMOUS + '/luffy.jpg';

    @wire(getPhotoId, {contId: '$contactid'})
    photo({data, error}){
        if(data){
            this.items = data;
            this.contURL = this.items[0];
            if(this.items[1] == 'empty'){
                this.photoURL = this.emptyPhoto;
                console.log(this.photoURL);
            }
            else{
                this.photoURL = this.items[1];
                console.log('Photo:: '+this.photoURL);
            }
        }
        if(error){
            this.error = error;
            this.data = undefined;
            console.log(this.error);
        }
    };

    @wire(getRecord, { recordId: '$contactid', fields: FIELDS })
    contact;

    get name() {
        return this.contact.data.fields.Name.value;
    }

    get title() {
        return this.contact.data.fields.Title.value;
    }

    get phone() {
        return this.contact.data.fields.Phone.value;
    }

    get email() {
        return this.contact.data.fields.Email.value;
    }
}