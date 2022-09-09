import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

import getDirectOrIndirectlyContacts from '@salesforce/apex/ContactController.getDirectOrIndirectlyContacts';

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'button', typeAttributes:{label:{fieldName:'Name'},variant:'base'}},
    { label: 'Email', fieldName: 'Email', type: 'email'},
    { label: 'Phone', fieldName: 'Phone', type: 'phone'},
];

export default class ContactSearch extends NavigationMixin(LightningElement) {
    @api recordId;
    @track contacts;
    initialContacts;
    error;
    columns=columns;
    showDetails = false;
    contactDetails;

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

    handleRowAction(event) {
        //console.log(this.initialContacts);
        this.showDetails = true;
        this.contactDetails = {...event.detail.row};
    }

    handleEnter (event) {
        if (event.keyCode === 13) {
            this.searchContact(event.target.value);
        }
    }

    handleSearchClick (event) {
        console.log(event.target.id);
    }

    handleCreate (event) {
        alert("Pressed");
        const defaultValues = encodeDefaultFieldValues({
            AccountId: this.recordId
        });

        console.log(defaultValues);

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

    searchContact (searchText) {
        let regex = new RegExp(searchText,'gi');
        this.contacts = this.initialContacts.filter(
            row => regex.test(row.Name)
        );
    }


    handleSearch(event) {
        let charCount = event.target.value.length;
        if (charCount === 3) {
            this.searchContact(event.target.value);
        } else if (charCount < 3) {
            this.contacts = this.initialContacts;
        }
    }
}