import { LightningElement, api, wire, track } from 'lwc';
import getContactsOnSearch from '@salesforce/apex/ContactSearchClass.getContactsOnSearch';
import getContacts from '@salesforce/apex/ContactSearchClass.getContacts';
import { NavigationMixin } from 'lightning/navigation';

const columns = [
  { label: 'Name', fieldName: 'Name', type: 'button', typeAttributes: { label: { fieldName: 'Name' }, variant: 'base' } },
  { label: 'Email', fieldName: 'Email', type: 'email' },
  { label: 'Phone', fieldName: 'Phone', type: 'phone' }
];
export default class ContactSearch extends NavigationMixin(LightningElement) {
  @api recordId;
  @track searchKey = '';
  @track contacts = [];
  @track mainContacts = [];
  @track error;
  @track showModal = false;
  recordCount;
  name = '';
  title = '';
  profilePic;
  phone;
  email;
  selectedContactId;
  showInfo = false;
  showTable = false;
  columns = columns;
  loadMoreStatus = '';
  limitSize = 5;
  offSet = 0;

  navigateToContact(){
    this[NavigationMixin.Navigate]({
      type: 'standard__recordPage',
      attributes: {
        recordId: this.selectedContactId,
        objectApiName: 'Contact',
        actionName: 'view'
      }
    })
  }

  getName(name) {
    return name;
  }
  getTitle(title) {
    return title;
  }
  getProfilePic(profilePic) {
    return profilePic;
  }
  getPhone(phone) {
    return phone;
  }
  getEmail(email) {
    return email;
  }
  handleRowAction(event) {
    const row = event.detail.row;
    this.showInfo = true;
    this.selectedContactId = row.Id;
    this.name = this.getName(row.Name);
    this.title = this.getTitle(row.Title);
    this.email = this.getEmail(row.Email);
    this.phone = this.getPhone(row.Phone);
    this.profilePic = this.getProfilePic(row.ProfilePicture__c);
  }
  handleClick() {
    this.showTable = true;
  }
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
      getContactsOnSearch({ contactName: this.searchKey, accountId: this.recordId }).then(response => {
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
    else if (event.target.value.length == 0)
      this.contacts = this.mainContacts;
  }
  loadData() {
    return getContacts({ limitSize: this.limitSize, offSet: this.offSet, accountId: this.recordId }).then(response => {
      if (this.contacts.length != 0 && response) {
        this.contacts = this.contacts.concat(response);
        this.mainContacts = this.mainContacts.concat(response);
        this.recordCount += response.length;
      }
      else {
        this.recordCount = response.length;
        this.contacts = response;
        this.mainContacts = this.contacts;
        this.error = undefined;
      }
      /*if (this.targetDatatable && this.data.length >= this.totalNumberOfRows) {
        //stop Infinite Loading when threshold is reached
        this.targetDatatable.enableInfiniteLoading = false;
        //Display "No more data to load" when threshold is reached
        this.loadMoreStatus = 'No more data to load';
      }*/
      //Disable a spinner to signal that data has been loaded
      if(response.length == 0) this.targetDatatable.enableInfiniteLoading = false;
      if (this.targetDatatable) this.targetDatatable.isLoading = false;

    }).catch(error => {
      this.error = error;
      this.contacts = undefined;
    })
  }
  loadMoreData(event) {

    //event.preventDefault();
    // increase the offset count by 20 on every loadmore event
    this.offSet = this.offSet + this.limitSize;
    //Display a spinner to signal that data is being loaded
    event.target.isLoading = true;
    //Set the onloadmore event taraget to make it visible to imperative call response to apex.
    this.targetDatatable = event.target;
    //Display "Loading" when more data is being loaded
    this.loadMoreStatus = 'Loading';
    // Get new set of records and append to this.data
    this.loadData();
  }

  showModalPopup() {
    this.showModal = true;
  }
  closeModal() {
    this.showModal = false;
  }
  get setTableHeight() {
    if (this.recordCount == 0) {//set the minimum height
      return 'height: 100px;';
    }
    else if (this.recordCount >= 5) {//set the max height
      return 'height: 200px;';
    }
    return '';
  }

}
