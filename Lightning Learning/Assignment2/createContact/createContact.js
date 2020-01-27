/* eslint-disable no-console */
import { LightningElement, track} from 'lwc';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import FAX_FIELD from '@salesforce/schema/Contact.Fax';
import createContact from '@salesforce/apex/CreateContact.createContactRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class createContactRecord extends LightningElement {

    firstname = FIRSTNAME_FIELD;
    lastname = LASTNAME_FIELD;
    phone = PHONE_FIELD;
    email = EMAIL_FIELD;
    fax = FAX_FIELD;
    rec = {
        FirstName : this.firstname,
        LastName : this.LastName,
        Phone : this.phone,
        Email : this.email,
        Fax : this.fax
    }

    handleFirstNameChange(event) {
        this.rec.FirstName = event.target.value;
    }
    
    handleIndChange(event) {
        this.rec.Industry = event.target.value;
    }
    
    handleLastNameChange(event) {
        this.rec.LastName = event.target.value;
    }
    handlePhoneChange(event) {
        this.rec.Phone = event.target.value;
    }
    handleEmailChange(event) {
        this.rec.Email = event.target.value;

    }
    validateEmailChange(event) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if(!event.target.value.match(regExpEmailformat)){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Invalid Mail',
                    message: 'Please enter a valid email address',
                    variant: 'error',
                }),
            );               
        }
        
    }
    handleFaxChange(event) {
        this.rec.Fax = event.target.value;
    }

    handleClick() {
        createContact({ cntct : this.rec })
            .then(result => {
                this.message = result;
                this.error = undefined;
                if(this.message !== undefined) {
                    this.rec.FirstName = '';
                    this.rec.LastName = '';
                    this.rec.Phone = '';
                    this.rec.Email = '';
                    this.rec.Fax = '';
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Contact created',
                            variant: 'success',
                        }),
                    );
                }
                
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
}