public class QueryEditorInputBoxController 
{
    public String queryInput{get;set;}
    public String sendQueryInput{get;set;}
    public Boolean showQueryOutput{get;set;}
    public QueryEditorInputBoxController()
    {
        showQueryOutput = false;
    }
    public PageReference executeQuery()
    {
        if(queryInput != null && queryInput != '')
        {
            sendQueryInput = queryInput;
            showQueryOutput = true;
        }
        return null;
    }
}