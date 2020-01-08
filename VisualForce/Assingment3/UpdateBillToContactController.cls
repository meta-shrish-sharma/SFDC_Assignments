public class UpdateBillToContactController 
{
    private String currentPageId;
    public String selectedCard{get;set;}
    private List<Contact> contactList;	
    public UpdateBillToContactController()
    {
        currentPageId = ApexPages.currentPage().getParameters().get('Id');
    }
    public List<SelectOption> getRecords()
    {
        List<Contact> contactList;
        List<SelectOption> cntctListSelection = new List<SelectOption>();
        Id accId = [SELECT Manager__c FROM Opportunity WHERE Id  = :currentPageId][0].Manager__c;
        if(accId != null)
        {
            contactList = [SELECT Id, Name FROM contact WHERE AccountId = :accId];
            for(Contact ct : contactList)
            {
                cntctListSelection.add(new SelectOption(ct.Id, ct.Name));
            }
            return cntctListSelection;
        }
        else
        {
            return null;
        }
    }
    public PageReference returnSavePage() 
    {
        // Send the user to the detail page for the new account.
        Opportunity op = [SELECT Name, BillToContact__c FROM opportunity WHERE Id = :currentPageId];  
        op.BillToContact__c = selectedCard; 
        update op;
        PageReference oppPage = new PageReference('/' + op.Id);
        return oppPage;
    }
    public PageReference returnCancelPage() 
    {
        PageReference oppPage = new PageReference('/' + currentPageId);
        return oppPage;
    }
    public PageReference returnClearPage() 
    {
        // Send the user to the detail page for the new account.
        Opportunity op = [SELECT Name, BillToContact__c FROM Opportunity WHERE Id = :currentPageId];  
        op.BillToContact__c = null; 
        update op;
        //redirect to opportunity page
        PageReference nextPage = new PageReference('/' + op.Id);
        return nextPage;
    }
}