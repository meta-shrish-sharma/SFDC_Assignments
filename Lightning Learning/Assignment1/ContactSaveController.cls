public class ContactSaveController 
{
    @AuraEnabled
    public static Contact saveContact(Contact newContact)
    {
        insert newContact;
        return newContact;
    }
}