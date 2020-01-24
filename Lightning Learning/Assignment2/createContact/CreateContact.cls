public class CreateContact 
{
    @AuraEnabled
    public static Contact createContactRecord(Contact cntct) 
    {
        insert cntct;
        return cntct;
    }
}