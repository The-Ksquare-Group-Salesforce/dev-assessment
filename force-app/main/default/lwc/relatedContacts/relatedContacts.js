import { LightningElement, api, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/AccountLWCController.getContacts';
import NAME_FIELD from '@salesforce/schema/Contact.Name';

const actions = [
    { label: 'Show details', name: 'show_details' },
];

export default class RelatedContacts extends LightningElement {
    main = true;
    @track columns = [
        /*{
            type:"button",
            fixedWidth: 150,
            typeAttributes: {
                label: 'View',
                name: 'view',
                variant: 'brand'
            }
        }*/
        {
            type: 'action',
            typeAttributes: { rowActions: actions },
        },
        {
            label: 'First Name',
            fieldName: 'FirstName'
        },
        {
            label: 'Last Name',
            fieldName: 'LastName'
        },
        {
            label: 'Email',
            fieldName: 'Email',
            type: 'email'
        },
        {
            label: 'Phone',
            fieldName: 'phone',
            type: 'phone'
        }
    ];

    @track contacts;
    @track contactId;
    @api recordId;
    searchVal = '';
    //wiredContacts;

    nameField = NAME_FIELD;

    @wire (getContacts, {currentAccount: '$recordId', searchVal: '$searchVal'}) wiredAccounts({data,error}){
        //this.wiredContacts = data;
        if (data) {
            this.contacts = data;
            this.contactId = data[0].Id;
            //console.log(data[0].attr('id'));
            //console.log(data[0].Id);
            //console.log(data[0].Id);
            //console.log(data[0]);
            console.log(data); 
            console.log(this.contactId);
        } else if (error) {
            this.contacts = undefined;
            console.log(error);
        }
    }

    handleSearch(event) {
        this.searchVal = event.target.value;
    }

    handleClick1(event) {
        console.log('a');
    }

    handleClick2(event) {
        this.main = false;
        console.log('b');
    }

    handleSuccess(event) {
        console.log('onsuccess event recordEditForm',event.detail.id)
    }

    handleSubmit(event) {
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
        this.main = true;
        //refreshApex(this.wiredContacts);
    }

    //record = this.contacts.first();

    handleRowActions(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.log(row);
        console.log(row.FirstName);
        const { id } = row;
        console.log('Record Id ==> '+ id);
    }
    
    /*handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                this.deleteRow(row);
                break;
            case 'show_details':
                this.showRowDetails(row);
                break;
            default:
        }
    }

    deleteRow(row) {
        const { id } = row;
        const index = this.findRowIndexById(id);
        if (index !== -1) {
            this.data = this.data
                .slice(0, index)
                .concat(this.data.slice(index + 1));
        }
    }*/
}