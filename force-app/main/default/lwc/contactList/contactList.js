import { LightningElement, api, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getRelatedContactList from '@salesforce/apex/ContactHelper.getRelatedContactList';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class ContactList extends NavigationMixin(LightningElement) {

    @track value;
    @track error;
    @track data;
    @track selectedContact;

    @api sortedDirection = 'asc';
    @api sortedBy = 'Name';
    @api searchKey = '';
    @api recordId;

    showNextButton = false;
    showPreviousButton = true;
    result;

    page = 1;
    items = [];
    contacts = [];

    startingRecord = 1;
    endingRecord = 0;
    pageSize = 5;
    totalRecordCount = 0;
    totalPage = 0;

    get recordsOptions() {
        return [
            { label: '5 ', value: '5' },
            { label: '10 ', value: '10' },
            { label: '15 ', value: '15' },
            { label: '20 ', value: '20' },
            { label: '25 ', value: '25' },
        ];
    }

    handleRecordsChange(e) {
        this.pageSize = e.target.value;
        this.page = 1;
        this.displayRecordPerPage(1);
        this.totalPage = Math.ceil(this.totalRecordCount / this.pageSize);
    }

    @wire(getRelatedContactList, { searchKey: '$searchKey', sortBy: '$sortedBy', sortDirection: '$sortedDirection', accId: '$recordId' })
    wiredContacts({ error, data }) {
        if (data) {
            this.selectedContact = null;
            this.page = 1;
            if (data.length === 0) {
                this.contacts = null;
                this.totalPage = 1;
                return;
            }
            this.totalRecordCount = data.length;
            this.totalPage = Math.ceil(this.totalRecordCount / this.pageSize);
            this.items = data;

            if (this.totalRecordCount < 1) this.page = 0;

            this.contacts = this.items.slice(0, this.pageSize);
            this.endingRecord = this.pageSize;

            this.refreshPagePerRecord();

            if (this.totalPage === 1) {
                this.showNextButton = true;
                this.showPreviousButton = true;
            }

            this.error = undefined;
        } else if (error) {
            this.totalPage = 0;
            this.error = error;
            this.contacts = undefined;
        }

    }

    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
            if (this.page === 1) this.showPreviousButton = true;
            if (this.page !== this.totalPage) this.showNextButton = false;
        }
    }

    nextHandler() {
        if ((this.page < this.totalPage) && this.page !== this.totalPage) {
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);
            if (this.page !== 1) this.showPreviousButton = false;
            if (this.page === this.totalPage) this.showNextButton = true;
        }
    }

    displayRecordPerPage(page) {

        this.startingRecord = ((page - 1) * this.pageSize);
        this.endingRecord = (this.pageSize * this.page);
        this.endingRecord = (this.endingRecord > this.totalRecordCount) ? this.totalRecordCount : this.endingRecord;
        this.contacts = this.items.slice(this.startingRecord, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;
    }

    sortColumns(e) {
        this.sortedBy = e.detail.fieldName;
        this.sortedDirection = e.detail.sortDirection;
        return refreshApex(this.result);
    }

    handleKeyChange(e) {
        if (e.target.value.length === 0) this.searchKey = '';
        if (e.target.value.length >= 3 || e.keyCode === 13) {
            this.searchKey = e.target.value;
            return refreshApex(this.result);
        }
    }

    handleSearch() {
        this.searchKey = this.template.querySelector('.search').value;
        return refreshApex(this.result);
    }

    onSelectHandler(e) {
        const contactId = e.detail;
        this.selectedContact = this.items.find((contact) => contact.Id === contactId);
    }

    refreshPagePerRecord() {
        if (this.totalRecordCount > Number(this.pageSize)) {
            this.showNextButton = false;
            this.showPreviousButton = true;
        }
    }

    handleImageClick() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                objectApiName: 'Contact',
                recordId: this.selectedContact.Id,
                actionName: 'view'
            }
        })
    }

    createContactHandler() {
        const defaultValues = encodeDefaultFieldValues({
            FirstName: 'Salesforce',
            LastName: 'Salesforce'
        })

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        })
    }

    closeHandler() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}
