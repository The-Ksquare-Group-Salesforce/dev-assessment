import { LightningElement, wire, track, api } from 'lwc';
import getAccounts from '@salesforce/apex/accountRelatedRecords.searchContacts';

export default class ContactSearch extends LightningElement {
    @api accountid;

    @track contactName = '';
    @track contactList = [];     
    @track contactId =''; 
    @track isshow=false;
    @track isShowResult = true;   
    @track showSearchedValues = false;   

    @wire(getAccounts, {contName:'$contactName', actId: '$accountid'})
    retrieveAccounts ({error, data}) {
       if (data) {
            if(data.length>0 && this.isShowResult){
                this.contactList = data;                
                if(data.length == 1){
                    this.contactId = this.contactList[0].Id;
                }
            }            
            else if(data.length==0){
                this.contactList = [];                
                this.showSearchedValues = false;      
            }  
               
        }else if (error) {
            // TODO: Data handling
            this.contactId =  '';
            this.contactName =  '';
            this.contactList=[];           
            this.showSearchedValues = false;
        }
    }

    handleKeyChange(event){
        if(event.target.value.length >= 3){
            this.contactName = event.target.value;
            this.showSearchedValues = true;
        }
        else{
            this.showSearchedValues = false;
        }
    }
    handleEnter(event){
        if(event.keyCode === 13){
            this.handleSearchedContact();
        }
    }  
    handleSearchedContact(){
        if(this.contactId != ''){
            this.showSearchedValues = false;
            this.contactName = '';
            var sendContactId = this.contactId;
            this.dispatchEvent(new CustomEvent('sendcontid', {detail:sendContactId}));
        }
    }
}