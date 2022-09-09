import { LightningElement, api, track} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import getContacts from '@salesforce/apex/AccountController.getContacts';

export default class AccountContactSearch extends NavigationMixin(LightningElement) {
    @track contacts;
    @api recordId;
    key;
    loading;
    contactInfo={};
    contactMap = new Map();
    rowLimit = 10;
    rowOffSet = 0;
    contactCard = false;
 

    handleKeyChange(event){
        this.key = event.target.value;
        if(this.key.length >= 3 || this.key.length === 0){
            this.handleSearch();
        }
    }

    handleKeyPressed(event){
        if(event.keyCode === 13){
            this.handleSearch();
        }
    }
    
    handleSearch(){
        getContacts({searchKey: this.key ? this.key:'',
                    accountId: this.recordId,
                    limitSize: this.rowLimit, 
                    offset : this.rowOffSet})
        .then(result=>{
            this.contacts = result;
            for(let i = 0 ; i < result.length ; i++){
                this.contactMap.set(result[i].Id, result[i]) 
            }
        })
        .catch(error=>{
            this.contacts = null;
        })
    }

    navigateToCreateContact() {
        const defaultValues = encodeDefaultFieldValues({
            AccountId: this.recordId
        });
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'new',
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }

    showContactCard(event) {
        this.contactId = event.target.dataset.id;
        this.contactInfo = this.contactMap.get(this.contactId);
        this.contactCard = Object.keys(this.contactInfo).length !== 0;
    }

    loadMoreData(event) {
        const currentRecord = this.contacts;
        event.target.isLoading = true;
        this.rowOffSet = this.rowOffSet + this.rowLimit;
        this.loadData()
            .then(()=> {
                event.target.isLoading = false;
            });   
    }

    renderedCallback(){
        if(!this.key){
            this.handleSearch();
        }
    }
}