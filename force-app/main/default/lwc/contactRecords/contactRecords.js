import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getContactsByAccountId from '@salesforce/apex/ContactController.getContactsByAccountId';
import getContactsByAccount from '@salesforce/apex/ContactController.getContactsByAccount';
import { NavigationMixin } from 'lightning/navigation';
// const columns = [
//     {label: 'First Name', fieldName: 'FirstName'},
//     {label: 'Last Name', fieldName: 'LastName'},
//     {label: 'Email', fieldName: 'email'},
// ]
const actions = [
    { label: 'View', name: 'show_details' },
    { label: 'Edit', name: 'edit_details' },
];

    export default class ContactRecords extends NavigationMixin(LightningElement) {
  
        columns =   [
            {type : 'action', typeAttributes: {rowActions: actions,}},
            {label: 'First Name', fieldName: 'FirstName'},
        {label: 'Last Name', fieldName: 'LastName'},
        {label: 'Email', fieldName: 'Email'},
        {label: 'Phone', fieldName: 'Phone'},
        {label: 'Title', fieldName: 'Title'},
        ];
    searchTerm = '';
    searchTermForButton = '';
    @api recordId;
    contactId;
    //@wire(getContactsByAccountId, {accountId: '$recordId'})contacts;
    //@wire(getRecord, {recordId: '$recordId'})Account;

    @wire(getContactsByAccount, {searchTerm: '$searchTermForButton',accountId: '$recordId'}) contacts;

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

    handleOnClickButton(event){

        this.searchTermForButton = this.searchTerm;
    }

    navigateToRecordViewPage(event) {
    
        if(event.detail.action.name == 'show_details')
        {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.row.Id,
                    objectApiName: 'Contact', // objectApiName is optional
                    actionName: 'view',
                }
            });
        }
        else if(event.detail.action.name == 'edit_details'){

            
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.row.Id,
                    objectApiName: 'Contact', // objectApiName is optional
                    actionName: 'edit',
                }
            });

        }

    }
}