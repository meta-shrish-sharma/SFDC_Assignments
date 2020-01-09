public class UpdateBillToContactController 
{
    private String currentPageId;
    public String selectedCard{get;set;}
    public Boolean showSelectList{get;set;}
    public Boolean showErrorList{get;set;}
    private List<Contact> contactList;
    private Id accId;
    private List<SelectOption> cntctListSelection;
    public UpdateBillToContactController()
    {
        showSelectList = true;
        showErrorList = false;
        currentPageId = ApexPages.currentPage().getParameters().get('Id');
        accId = [SELECT Manager__c FROM Opportunity WHERE Id  = :currentPageId][0].Manager__c;
        if(accId != null)
        {
            cntctListSelection = new List<SelectOption>();
            contactList = [SELECT Id, Name FROM contact WHERE AccountId = :accId];
            if(contactList.size() > 0)
            {
            for(Contact ct : contactList)
            {
                cntctListSelection.add(new SelectOption(ct.Id, ct.Name));
            }
            }
            else
            {
                noRecordsFound();
            }
        }
        else
        {
            noRecordsFound();
        }
    }
    public void noRecordsFound()
    {
        showSelectList = false;
        showErrorList = true;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No records found'));
    }
    public List<SelectOption> getRecords()
    {
        return cntctListSelection;
        
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