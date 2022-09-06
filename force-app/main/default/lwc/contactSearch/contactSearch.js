import { LightningElement, track } from 'lwc';
import getContact from '@salesforce/apex/ContactController.getContact';
export default class ContactSearch extends LightningElement {
    key;
    theFinder
    @track contacts;
    placeholder = "Search";
    updateKey(event) {
        this.key = event.target.value;


    }


    handleSearch() {
        getContact({ searchKey: this.key })
            .then(result => {
                this.contacts = result;

            })
            .catch(error => {
                this.contacts = null;
            });

    }

    cols = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'E-mail', fieldName: 'email', type: 'text' },
        { label: 'Phone', fieldName: 'Phone', type: 'text' }

    ]
}