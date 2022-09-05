import { LightningElement, api, track, wire } from 'lwc';

import relatedContacts from '@salesforce/apex/GetRelatedContacts.GetContacts';

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'email', fieldName: 'Email', type: 'email' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },

];

export default class AccountRelatedContacts extends LightningElement {
    
    @api recordId;
    @track allRecords;
    @track filterRecords;
    @track contacts;
    columns = columns;
    


    @wire(relatedContacts,{accountId:'$recordId'})
    wiredContacts({data, error}){

        if(data){
          this.contacts = data;
          this.allRecords = data;
          this.error = undefined;
        }
        else if(error){
          this.error = error;
          this.contacts = undefined;
        }
      }


    searchOnChange(event){
        
        const nameSearch = event.target.value.toLowerCase();

        if (nameSearch.length >= 3) {

          this.contacts = this.allRecords;
            
          if (this.contacts) {
            let fiteredRecords = [];

            for (let record of this.contacts) {
                let rowRecord = Object.values(record);

                for (let fieldValue of rowRecord) {
                  let strFieldValue = String(fieldValue);

                  if (strFieldValue != null && strFieldValue.toLocaleLowerCase().includes(nameSearch)){
                    fiteredRecords.push(record);
                    break;
                  }
                  
                }
              
            }
            this.contacts = fiteredRecords;
          }else{
            this.contacts = this.allRecords;
          }
        }else{
          this.contacts = this.allRecords;
        }
    }
   
}
