import { LightningElement, api, wire } from 'lwc';
import getContactsByAccount from '@salesforce/apex/ContactController.getContactsByAccount';
import { NavigationMixin } from 'lightning/navigation';

const actions = [
    { label: 'View', name: 'show_details' },
    { label: 'Edit', name: 'edit_details' },
];

export default class ContList extends NavigationMixin(LightningElement) {
  
    columns =   [
        {type : 'action',     typeAttributes: {rowActions: actions,}},
        {label: 'First Name', fieldName: 'FirstName'},
        {label: 'Last Name',  fieldName: 'LastName'},
        {label: 'Email',      fieldName: 'Email'},
        {label: 'Phone',      fieldName: 'Phone'},
        {label: 'Title',      fieldName: 'Title'},
    ];

    searchStr = '';
    searchStrBtn = '';
    @api recordId;
    contactId;

    @wire(getContactsByAccount, {searchStr: '$searchStrBtn',accountId: '$recordId'}) contacts;

    handleSearchStrChange(event) {
		window.clearTimeout(this.delayTimeout);
		const searchStr = event.target.value;

		this.delayTimeout = setTimeout(() => {
			this.searchStr = searchStr;
		}, 300);
	}

    handleOnClickButton(event){

        this.searchStrBtn = this.searchStr;
    }

    navigateToRecordViewPage(event) {
    
        if(event.detail.action.name == 'show_details')
        {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.row.Id,
                    objectApiName: 'Contact',
                    actionName: 'view',
                }
            });
        }
        else if(event.detail.action.name == 'edit_details'){

            
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.row.Id,
                    objectApiName: 'Contact',
                    actionName: 'edit',
                }
            });
        }
    }
}