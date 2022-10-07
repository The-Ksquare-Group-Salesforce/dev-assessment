import { LightningElement } from 'lwc';
const columns = [
    {
        label: 'Contact Name', fieldName: 'Contact.Name', type: 'Text',
    },
    { label: 'Email', fieldName: 'Contact.Email', type: 'text' },
    { label: 'Phone', fieldName: 'Contact.Phone', type: 'text' }
 ];
export default class ContactSearchDataTable extends LightningElement {
    columns = columns;
}