import { LightningElement, api, wire} from 'lwc';
import getContacts from '@salesforce/apex/ContactSearchClass.getContacts';


const columns = [
  { label: 'Name', fieldName: 'Name' },
  {label: 'Email', fieldName:'Email', type: 'email'},
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
  columns = columns;
  @wire(getContacts, {accountId: '$recordId'})
  contacts;
  // connectedCallback(){
  //   getContacts({accID: this.recordId}).then(contacts => {
  //     //console.log(`%c ${JSON.stringify(contacts,null,2)}`, 'color:green; font-weight:bold; font-size:14px;');
  //     console.log(contacts);
  //     this.count = contacts;
  //   });
  // }
}
