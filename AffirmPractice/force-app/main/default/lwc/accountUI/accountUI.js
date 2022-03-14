import { LightningElement, track, wire } from 'lwc';
import getAccountList from '@salesforce/apex/AccountController.getAccountList';
import getAccountDetail from '@salesforce/apex/AccountController.getAccountDetail';

export default class AccountUI extends LightningElement {

    @track isloading = false;
    @track isDetailView = false;
    @track accounts = [];
    @track selectedAccount; // string
    @track account={};
    @track ownerName; // string
    @track mediumPhotoUrl;// string

    @wire(getAccountList)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
        } else if (error) {
            console.log(error);
        }
    }

    handleButtonClick(event){
        const selectedAccount = event.target.value;
        this.accounts = this.accounts.map(account =>{
            if(account.Id === selectedAccount){
                return account = {...account, isSelected : true};
            }else{
                return account = {...account, isSelected : false};
            }
        });
        this.selectedAccount = selectedAccount;
    }

    handleNextClick(){
        if(this.selectedAccount){
            this.isloading = true;
            getAccountDetail({recordId: this.selectedAccount}).then(account => {
                this.account= account;
                this.mediumPhotoUrl = account.Owner.MediumPhotoUrl;
                this.ownerName = account.Owner.Name;
                this.isloading = false;
            }).catch(error=> console.log(error)); // can add this.isloading = false if needed;
            this.isDetailView = true;
        }else{
            alert('Please select an account before clicking next');
        }

    }

    handleBackClick(){// reset value
        this.isDetailView = false;
        this.account={};
    }
}