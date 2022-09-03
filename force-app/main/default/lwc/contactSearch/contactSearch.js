import { LightningElement, api, wire, track} from 'lwc';
import getContacts from '@salesforce/apex/ContactSearchClass.getContacts';


const columns = [
  { label: 'Name', fieldName: 'Name' },
  { label: 'Email', fieldName:'Email', type: 'email'},
  { label: 'Phone', fieldName: 'Phone', type: 'phone' }
];
// const data = [
//   {
//       id: 'a',
//       Name: 'Abel',
//       Email: '1234@email.com',
//       Phone: '2352235235',
//   },
//   {
//     id: 'b',
//     Name: 'Fernando',
//     Email: '12345@email.com',
//     Phone: '2352235235',
//   },
// ];
export default class ContactSearch extends LightningElement {
  @api recordId;
  @track searchKey = '';
  @track contacts;
  @track error;
  columns = columns;
  searchContact(event){
    if(event.target.value.length > 3){
      this.searchKey = event.target.value;
    }
  }
  @wire(getContacts, {contactName: '$searchKey', accountId: '$recordId'})
  wiredContacts({ data, error }){
    if(data){
      this.contacts = data;
      this.error = undefined;
    }
    else if(error){
      this.error = error;
      this.contacts = undefined;
    }
  }
  // connectedCallback(){
  //   getContacts({accID: this.recordId}).then(contacts => {
  //     //console.log(`%c ${JSON.stringify(contacts,null,2)}`, 'color:green; font-weight:bold; font-size:14px;');
  //     console.log(contacts);
  //     this.count = contacts;
  //   });
  // }
}
