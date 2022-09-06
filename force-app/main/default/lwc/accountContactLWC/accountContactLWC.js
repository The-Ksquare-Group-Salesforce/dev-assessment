import { LightningElement, api, wire, track } from 'lwc';

import contact from '@salesforce/apex/ContactsAccountClass.importContacts'

export default class AccountContactLWC extends LightningElement {
    @track data;
    @track error;
    @track dataColumns = dataColumns;
    @track searchString;
    @track initialRecords;
    @track rowId;


    @api recordId;
    @api Account;

    Idtag = "";
    ImgTag = "";
    NameTag = "";
    Titletag = "";
    EmailTag = "";
    PhoneTag = "";


    dataColumns = dataColumns;
    @wire(contact, { id: '$recordId' })


    getContacts({ error, data }) {
        this.data = data;
        this.initialRecords = this.data;

    };

    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();

        if (searchKey.length >= 3) {
            if (searchKey) {
                this.data = this.initialRecords;

                if (this.data) {
                    let searchRecords = [];

                    for (let record of this.data) {

                        let valuesArray = Object.values(record);

                        for (let val of valuesArray) {
                            let strVal = String(val);

                            if (strVal) {

                                if (strVal.toLowerCase().includes(searchKey)) {
                                    searchRecords.push(record);
                                    break;
                                }
                            }
                        }
                    }

                    console.log('Matched Accounts are 2' + JSON.stringify(searchRecords));
                    this.data = searchRecords;
                }
            } else {

                this.data = this.initialRecords;
            }
        } else {

            this.data = this.initialRecords;
        }
    }

    handleClick(event) {
        const row = event.detail.row;

        this.ImgTag = row.Profile_Picture__c;
        this.NameTag = row.Name;
        this.TitleTag = row.Title;
        this.EmailTag = row.Email;
        this.PhoneTag = row.Phone;
        this.Idtag = row.Id;

    }

    handleShowModal() {
        const modal = this.template.querySelector("c-modal-Popup");
        modal.show();
    }

}

const dataColumns = [
    { label: 'Name', fieldName: 'Name', type: 'button', typeAttributes: { label: { fieldName: 'Name' }, variant: 'base' } },
    { label: 'Email', fieldName: 'Email', type: 'email' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' }
];