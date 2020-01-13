public class PaginationController 
{
    public Integer noOfRecords{get;set;}
    public Integer size{get;set;}
    public Integer inputTotalNoOfRecords{get;set;} // input text1 value  from vf
    public String inputBillingCity{get;set;} // input text2 value  from vf
    public String inputBillingState{get;set;} 
    public String inputBillingCountry{get;set;} 
    public ApexPages.StandardSetController setCon 
    {
        get{
            if(setCon == null){
                if (inputTotalNoOfRecords == null)
                {
                    size = 10;
                }
                else
                {
                    size = inputTotalNoOfRecords;
                }
                String queryString = 'SELECT Name, Type, BillingCity, BillingState, BillingCountry FROM Account';
                String whereQueryString = '';
                if(inputBillingCity != null && inputBillingCity != '')
                {
                    whereQueryString = ' BillingCity = \'' + inputBillingCity + '\' ';
                }
                if(inputBillingState != null && inputBillingState != '')
                {
                    if(whereQueryString != null && whereQueryString != '')
                    {
                        whereQueryString = whereQueryString + ' AND ';
                    }
                    whereQueryString = whereQueryString + ' BillingState = \'' + inputBillingState + '\' ';
                }
                if(inputBillingCountry != null && inputBillingCountry != '')
                {
                    if(whereQueryString != null && whereQueryString != '')
                    {
                        whereQueryString = whereQueryString + ' AND ';
                    }
                    whereQueryString = whereQueryString + ' BillingCountry = \'' + inputBillingCountry + '\'';
                }
                if(whereQueryString != null && whereQueryString != '')
                {
                    whereQueryString = ' WHERE ' + whereQueryString;
                    queryString = queryString + whereQueryString;
                }
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }set;
    }
    Public List<Account> getAccounts()
    {
        List<Account> accList = new List<Account>();
        for(Account a : (List<Account>)setCon.getRecords())
            accList.add(a);
        return accList;
    }
    public pageReference refresh() {
        setCon = null;
        getAccounts();
        setCon.setPageNumber(1);
        return null;
    }
}