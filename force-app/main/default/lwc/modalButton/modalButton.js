import { LightningElement, api } from "lwc";

export default class ModalButton extends LightningElement {
    @api recordId;
    
    handleShowModalContainer() {
        const modalCont = this.template.querySelector("c-modal-container");
        modalCont.showModalContainer();
    }
}