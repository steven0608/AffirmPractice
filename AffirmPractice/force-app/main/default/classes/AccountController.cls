/**
 * @description       : AccountController for AccountUI lwc
 * @author            : Steven Chen
 * @group             : 
 * @last modified on  : 03-14-2022
**/
public with sharing class AccountController {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        return [SELECT Id, Name FROM Account LIMIT 5];
    }

    @AuraEnabled
    public static Account getAccountDetail(String recordId){
        return [SELECT Id, Name, Industry, Type, owner.name, Owner.MediumPhotoUrl FROM Account WHERE Id =:recordId LIMIT 1];
    }
}
