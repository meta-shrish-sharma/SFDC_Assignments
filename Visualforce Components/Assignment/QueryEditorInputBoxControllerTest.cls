@isTest
public class QueryEditorInputBoxControllerTest 
{
    @isTest
    static void queryEditorInputBoxControllerTest_sendQuery_getQueryOutputVisible()
    {
        QueryEditorInputBoxController queryEditor = new QueryEditorInputBoxController();
        queryEditor.queryInput = 'SELECT Id, Name FROM Account';
        queryEditor.executeQuery();
        System.assertEquals(queryEditor.sendQueryInput, queryEditor.queryInput);
        System.assert(queryEditor.showQueryOutput);
    }
}