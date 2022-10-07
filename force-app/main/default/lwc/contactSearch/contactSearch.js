import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { CloseActionScreenEvent } from 'lightning/actions';
import lookUp from '@salesforce/apex/ContactSearchController.search';
import searchSingleContact from '@salesforce/apex/ContactSearchController.searchSingleContact';
const columns = [
    {label: 'Name', fieldName: 'Name', type: 'button',
    typeAttributes: {label:{fieldName: 'Name'},variant: 'base'}},
    { label: 'Email', fieldName: 'Email', type: 'email' },
    { label: 'Phone', fieldName: 'Phone', type: 'text' }
 ];
export default class ContactSearch  extends NavigationMixin(LightningElement) {
    columns = columns;
    searchPlaceholder='Search';
    error;
    searchTerm;
    rowLimit = 5;
    rowOffSet = 0;
    objectApiName = 'Contact';
    @api recordId;
    @track records = [];
    @track selectedContactId;
    @track urlPhotoConctat;
    showContactCard = false;

    onChange(event){
        if(event.target.value.length >= 3){
            this.searchTerm = event.target.value;
            this.records = [];
            this.rowOffSet = 0;
            this.getRecords();
        }
    }

    getRecords(){
        return lookUp({searchTerm : this.searchTerm, recordId : this.recordId, limitSize : this.rowLimit, offset : this.rowOffSet})
            .then(result => {
                let updatedRecords = [...this.records, ...result];
                this.records = updatedRecords;
                console.log(this.records.length)
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.records = undefined;
            })
    }

    loadMoreData(event){
        const { target } = event;
        target.isLoading = true;

        this.rowOffSet = this.rowOffSet + this.rowLimit;
        this.getRecords()
            .then(()=>{
                target.isLoading = false;
            });
    }

    searchContact(){
        searchSingleContact({searchTerm : this.searchTerm, recordId : this.recordId})
        .then(result => {
            this.selectedContactId = result.Id;
            this.urlPhotoConctat = result.Url
        })
        .catch(error => {
            this.error = error;
            this.records = undefined;
        })
    }

    viewRecord(event) {
        const row = event.detail.row;
        console.log(JSON.stringify(row));
        this.selectContact(row);
    }

    selectContact(contactInfo){
        this.showContactCard = true;
        this.selectedContactId = contactInfo.Id;
        this.urlPhotoConctat = contactInfo.Url
    }

    navigateToNewContact() {
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

    closeModal(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}