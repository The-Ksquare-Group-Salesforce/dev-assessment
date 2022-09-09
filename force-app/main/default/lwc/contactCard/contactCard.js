import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ContactCard extends NavigationMixin(LightningElement) {
    @api contactinfo;
    profilePicture;

    handleContact() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                objectApiName: 'Contact',
                recordId: this.contactinfo.Id,
                actionName: 'view'
            },
        });
    }

    connectedCallback(){
        if(this.contactinfo.Profile_Picture__c){
            this.profilePicture = this.contactinfo.Profile_Picture__c;
        }else{
            this.profilePicture = window.location.origin + '/_slds/images/themes/lightning_blue/lightning_blue_profile_avatar_200.png'
        }
    }


    
}