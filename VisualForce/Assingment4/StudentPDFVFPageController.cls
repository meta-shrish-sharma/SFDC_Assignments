public class StudentPDFVFPageController 
{
    private String currentPageId;
    private String pdfName;
    public StudentPDFVFPageController()
    {
        currentPageId = ApexPages.currentPage().getParameters().get('Id');
    }
    public Student__c getStudents()
    {
        Student__c st= new Student__c();
        st = [SELECT Name, Age__c, Sex__c, DOB__c FROM Student__c WHERE Id =  :currentPageId];
        pdfName = st.Name;
        return st;
    }
    public PageReference returnSavePDF() 
    {
        // Send the user to the detail page for the new account.
        PageReference pdf = Page.StudentPDFGenerator;
        // add parent id to the parameters for standardcontroller
        pdf.getParameters().put('id', currentPageId);
        Attachment attachDelete = new Attachment();
        //Delete if atachment already exist
        try
        {
            attachDelete = [SELECT Id FROM Attachment WHERE ParentId = :currentPageId];
            delete attachDelete;
        }
        catch (QueryException e) 
        {
            attachDelete = null;
        }
        // create the new attachment
        Attachment attach = new Attachment();
        // the contents of the attachment from the pdf
        Blob body;
        try 
        {
            // returns the output of the page as a PDF
            body = pdf.getContent();
        } 
        catch (VisualforceException e) 
        {
            body = Blob.valueOf('Some Text');
        }
        attach.Body = body;
        // add the user entered name
        attach.Name = pdfName;
        attach.IsPrivate = false;
        // attach the pdf to the account
        attach.ParentId = currentPageId;
        insert attach;
        // send the user to the account to view results
        return new PageReference('/' + currentPageId);
    }
}
