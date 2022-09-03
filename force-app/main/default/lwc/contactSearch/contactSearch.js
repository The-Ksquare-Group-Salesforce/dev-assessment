import { LightningElement, api, wire, track } from 'lwc';
import getContactsOnSearch from '@salesforce/apex/ContactSearchClass.getContactsOnSearch';
import getContacts from '@salesforce/apex/ContactSearchClass.getContacts';

const columns = [
  { label: 'Name', fieldName: 'Name' },
  { label: 'Email', fieldName: 'Email', type: 'email' },
  { label: 'Phone', fieldName: 'Phone', type: 'phone' }
];
export default class ContactSearch extends LightningElement {
  @api recordId;
  @track searchKey = '';
  @track contacts = [];
  @track mainContacts = [];
  @track error;
  columns = columns;
  limitSize = 10;
  offSet = 0;
  connectedCallback() {
    this.loadData();
  }
  searchContact(event) {
    if (event.target.value.length >= 3) {
      this.searchKey = event.target.value.toLowerCase();
      /*for (const contact of this.mainContacts) {
        if (contact.Name.toLowerCase().includes(this.searchKey)) {
          searchedTempContacts.push(contact);
        }
        this.contacts = searchedTempContacts;
      }*/
      this.loadData();
    }
    else if (event.target.value.length == 0)
      this.contacts = this.mainContacts;
  }
  loadData() {
    if (this.mainContacts.length > 0) {
      return getContactsOnSearch({ contactName: this.searchKey, accountId: this.recordId }).then(response => {
        let searchedTempContacts = [];
        this.contacts = response;
        this.error = undefined;
        for (const contact of this.mainContacts) {
          if (contact.Name.toLowerCase().includes(this.searchKey)) {
            searchedTempContacts.push(contact);
          }
          this.contacts = searchedTempContacts;
        }

      }).catch(error => {
        this.error = error;
        this.contacts = undefined;
      })
    }
    return getContacts({ limitSize: this.limitSize, offSet: this.offSet, accountId: this.recordId }).then(response => {
      this.contacts = response;
      this.mainContacts = response;
      this.error = undefined;

    }).catch(error => {
      this.error = error;
      this.contacts = undefined;
    })
  }
}
