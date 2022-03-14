/**
* @author Steven Chen
* @date 03/13/2022
*
* @description Trigger Handler on contact
*/
public with sharing class ContactTriggerHandler {

    /*
    * @description pulls the Industry field from the related Account and populates the Account_Industry__c field on the Contact 
    * returns true if enabled.
    */
    public static void updateAccountIndustryOnContact (List<contact> newContacts){
        Set<Id> setOfAccountIds = New Set<Id>();
        
        
        FOR(Contact ContactRecord : newContacts){
            setOfAccountIds.add(ContactRecord.AccountId); // get related AccountIds 
        }
        
        Map<Id, Account> mapOfAccountIdToIndustry = New Map<Id, Account>([SELECT Id, Industry FROM Account WHERE id IN :setOfAccountIds]);
        FOR(Contact ContactRecord : newContacts){
            ContactRecord.Account_Industry__c = mapOfAccountIdToIndustry.get(ContactRecord.AccountId)?.Industry; // if account is not empty, populate industry field
        }
    }
}