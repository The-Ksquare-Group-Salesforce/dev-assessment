import { LightningElement, track, wire, api} from 'lwc';
import getContacts from '@salesforce/apex/ContactsListController.getContactList';

export default class ContactList extends LightningElement {
    @track contactList;
    @api recordId;


    @track columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Title', fieldName: 'Title'},
        { label: 'Phone', fieldName: 'Phone'},
        { label: 'Email', fieldName: 'Email'}
    ];
    searchTerm = '';
    @wire (getContacts, {currentAccount: '$recordId', searchTerm: '$searchTerm'}) wiredAccounts({data,error}){
        if (data) {
             this.contactList = data;
        console.log(data); 
        } else if (error) {
        console.log(error);
        }
   }
   handleSearchTermChange(event) {
    // Debouncing this method: do not update the reactive property as
    // long as this function is being called within a delay of 300 ms.
    // This is to avoid a very large number of Apex method calls.
    window.clearTimeout(this.delayTimeout);
    const searchTerm = event.target.value;
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    this.delayTimeout = setTimeout(() => {
        this.searchTerm = searchTerm;
    }, 300);
}

}