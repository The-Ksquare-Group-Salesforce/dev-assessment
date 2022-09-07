import { LightningElement, api } from 'lwc';

export default class ContactDetail extends LightningElement {
    @api contactid
    @api imageurl

    handleOpenRecordClick() {
		const selectEvent = new CustomEvent('contactview', {
			detail: this.contactid
		});
        console.log(selectEvent.detail+"hola")
		this.dispatchEvent(selectEvent);
	}
    handleCreation(){
        const selectEvent = new CustomEvent('contactnew', {
			detail: this.contactid
		});
        console.log(selectEvent.detail+"hola")
		this.dispatchEvent(selectEvent);
    }
}