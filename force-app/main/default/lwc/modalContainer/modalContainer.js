import { LightningElement, api } from "lwc";


export default class ModalContainer extends LightningElement {
    @api accountid;
    showThisModal = false;

    @api showModalContainer() {
        this.showThisModal = true;
    }
    handleCloseModal() {
        this.showThisModal = false;
    }
    handleShowModal() {
        const modalNewContact = this.template.querySelector("c-modal-for-new-contact");
        modalNewContact.showContactModal();
    }
    refreshContacts(){
        console.log('Asking for refresh')
        const contactsAccount = this.template.querySelector("c-contacts-from-account");
        setTimeout(()  =>{
            contactsAccount.doRefresh();
        }, 1000)
    }
}