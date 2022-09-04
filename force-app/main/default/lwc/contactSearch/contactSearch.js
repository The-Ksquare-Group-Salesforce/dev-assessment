import { LightningElement } from 'lwc';

export default class ContactSearch extends LightningElement {


    greeting = 'World';
    changeHandler(event) {
      this.greeting = event.target.value;
    }

}