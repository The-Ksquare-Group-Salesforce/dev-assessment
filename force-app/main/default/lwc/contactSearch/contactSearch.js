import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { CloseActionScreenEvent } from 'lightning/actions';

import getDirectOrIndirectlyContacts from '@salesforce/apex/AccountController.getDirectOrIndirectlyContacts';

const columns = [
    { label: 'Name', type: 'button', typeAttributes: { label: { fieldName: 'Name' }, variant: 'base'}},
    { label: 'Email', fieldName: 'Email', type: 'email'},
    { label: 'Phone', fieldName: 'Phone', type: 'phone'},
];

export default class ContactSearch extends NavigationMixin(LightningElement) {
    @api recordId;
    @track contacts;
    initialContacts;
    error;
    columns=columns;
    contactDetails;
    searchString;

    @wire(getDirectOrIndirectlyContacts, { accountId: '$recordId' })
    wiredContacts({error, data}) {
        if (data) {
            this.contacts = data;
            this.initialContacts = data;
            this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    };

    handleRowAction (event) {
        this.contactDetails = {...event.detail.row};
    }

    handleSearch (event) {
        if (event.keyCode === 13 || event.target.dataset.name === 'searchButton') this.searchContact(this.searchString);
    }

    handleClick () {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.contactDetails.Id,
                objectApiName: 'Contact',
                actionName: 'view',
            }
        });
    }

    handleCreate () {
        const defaultValues = encodeDefaultFieldValues({
            AccountId: this.recordId
        });

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }

    // Search function using filter with regex expression wih 'gi' modifier (ignores case & match all instances)
    searchContact (searchText) {
        let regex = new RegExp(searchText,'gi');
        this.contacts = this.initialContacts.filter(
            row => regex.test(row.Name)
        );
    }

    handleClose() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleChange (event) {
        this.searchString = event.target.value;
        let charCount = this.searchString.length;
        if (charCount === 3) {
            this.searchContact(this.searchString);
        } else if (charCount < 3) {
            this.contacts = this.initialContacts;
        }
    }
}