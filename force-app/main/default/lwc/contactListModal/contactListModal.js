import { LightningElement, api, track } from 'lwc';

export default class ContactListModal extends LightningElement {
    @api recordId; 

    @track isShowModal = false;
    @track isShowCreateContact = false;

    showModalBox() {  
        this.isShowModal = true;
    }

    hideModalBox() {  
        this.isShowModal = false;
    }
    hideNewContactBox() {  
        this.isShowModal = true;
        this.isShowCreateContact = false;

    }

    handleNewContact (){
        this.isShowModal = false;
        this.isShowCreateContact = true;
    }

}