@isTest
public class QueryExecuterControllerTest 
{
    @testSetup 
    static void setup() 
    {
        List<Account> accList = new List<Account>();
        for(Integer accountCount = 0; accountCount < 20; accountCount++)
        {
            accList.add(new Account (Name = 'Test Account ' + accountCount));
        }
        upsert accList;
    }
    @isTest
    static void queryExecuterControllerTest_testWrongQuery_getErrorMessage()
    {
        QueryExecuterController queryExecuter = new QueryExecuterController();
        queryExecuter.setqueryString('SELECT FROM Account');
        // Query output page block should get invisible
        System.assertEquals(false, queryExecuter.renderPB);
        // Get error message
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean foundErrorMessage = false;
        for(Apexpages.Message msg:msgs)
        {
            if (msg.getDetail().contains('Please enter the correct query')) 
                foundErrorMessage = true;
        }
    }
    @isTest
    static void queryExecuterControllerTest_zeroRecords_getErrorMessage()
    {
        QueryExecuterController queryExecuter = new QueryExecuterController();
        queryExecuter.setqueryString('SELECT Id, Name FROM Contact');
        // Query output page block should get invisible
        System.assertEquals(false, queryExecuter.renderPB);
        // Get error message
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean foundErrorMessage = false;
        for(Apexpages.Message msg:msgs)
        {
            if (msg.getDetail().contains('No records found')) 
                foundErrorMessage = true;
        }
    }
    @isTest
    static void queryExecuterControllerTest_queryOutput_getRecords()
    {
        QueryExecuterController queryExecuter = new QueryExecuterController();
        queryExecuter.setqueryString('SELECT Name FROM Account');
        // Query output page block should get visible
        System.assertEquals(true, queryExecuter.renderPB);
        // output size
        System.assertEquals(20, queryExecuter.totalRecs);
    }
    
    @isTest
    static void queryExecuterControllerTest_recordsSorting_getSortedRecords()
    {
        QueryExecuterController queryExecuter = new QueryExecuterController();
        // First sort in ASC order
        queryExecuter.sortExpression = 'Name';
        queryExecuter.setqueryString('SELECT Name FROM Account');
        List<Account> queryOutput = (List<Account>)queryExecuter.lstObjs;
        // Maximum price at top
        System.assertEquals('Test Account 0', queryOutput[0].Name);
        // Then sort in DESC order
        queryExecuter.sortExpression = 'Name';
        queryExecuter.setqueryString('SELECT Name FROM Account');
        queryOutput = (List<Account>)queryExecuter.lstObjs;
        // 10 records are fetched at a time and 9 wull be at top
        System.assertEquals('Test Account 9', queryOutput[0].Name);
    }
    @isTest
    static void queryExecuterControllerTest_queryOutputPagination_runPagination()
    {
        QueryExecuterController queryExecuter = new QueryExecuterController();
        queryExecuter.setqueryString('SELECT Name FROM Account');
        // Test has previous
        System.assertEquals(true, queryExecuter.getprev());
        // Test has next
        System.assertEquals(false, queryExecuter.getnxt());
        // Go to next page
        queryExecuter.next();
        System.assertEquals(2, queryExecuter.pageNumber);
        // Go to previous page
        queryExecuter.previous();
        System.assertEquals(1, queryExecuter.pageNumber);
        // Go to end page
        queryExecuter.end();
        System.assertEquals(2, queryExecuter.pageNumber);
        // Test has previous
        System.assertEquals(false, queryExecuter.getprev());
        // Test has next
        System.assertEquals(true, queryExecuter.getnxt());
        // Go to first page
        queryExecuter.beginning();
        System.assertEquals(1, queryExecuter.pageNumber);
        // Go to page button test
        queryExecuter.inputPageNumber = 2;
        queryExecuter.goToPageNumber();
        System.assertEquals(2, queryExecuter.pageNumber);
    }
}