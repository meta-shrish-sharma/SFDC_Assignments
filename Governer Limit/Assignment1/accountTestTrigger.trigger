/*
1. SOQL inside the loop which may impact max limit of query execution
2. Update operation inside loop which may impact max limit of query execution
3. Multiple Loops are not required operation can be performed on Contact object by getting keyset of accounts.
4. Update operation should be performed on list operation rather then performing operation individually on all objects
5. Remove Debug statement before deploying code.
*/
trigger accountTestTrigger on Account (before insert, before update) 
{
    List<Contact> ctList = [SELECT Id, Salutation, Firstname, Lastname, Email FROM Contact WHERE accountId IN :Trigger.newMap.KeySet()];
    for(Contact c: ctList) 
    {
        c.Description=c.salutation + ' ' + c.firstName + ' ' + c.lastname;
    }
    update ctList;
}