import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

export default class ContactSearch extends NavigationMixin(LightningElement) {
    @api recordId;
    @api contactId;
    @api image

    handleChild(event){
        this.contactId = event.detail.ContactIdVal;
        this.image = event.detail.Imageurl;
    }
    handlecontactView(event) {
		const contactId = event.detail;
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: contactId,
				objectApiName: 'Contact',
				actionName: 'view',
			},
		});
	}
	handleCreate(){
		const defaultValues = encodeDefaultFieldValues({
            AccountId: this.recordId
        });

        console.log(defaultValues);

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
	}
}