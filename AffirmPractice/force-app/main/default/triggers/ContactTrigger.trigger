/**
* @author Steven Chen
* @date 03/13/2022
*
* @description contact trigger (Before insert, before update)
*/
trigger ContactTrigger on Contact (before insert, before update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
			ContactTriggerHandler.updateAccountIndustryOnContact(Trigger.New); // update account industry field on contact when records are insert/update
        }
    }
}