public class QueryExecuterController 
{
    public List<sObject> lstObjs{get;set;}
    public List<String> lstFlds{get;set;}
    public String sortDirection{get;set;}
    private String sortExp;
    public Boolean renderPB{get;set;}
    // Whole expression used for sorting
    private String sortFullExp;
    // Get the string of all fields in query seperated by comma
    private String fieldsName;
    // Variables for pagination of Products
    private List<sObject> countLstObjs;
    public Integer totalRecs{get;set;}       
    private Integer index = 0;  
    public Integer pageBlockSize{get;set;}
    public Integer pageNumber{get;set;}
    public Integer inputPageNumber{get;set;}
    private String queryLowerCase;
    public String queryString;
    public String sortExpression 
    {
        get
        {
            return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }
    public void setqueryString(String inputValue) 
    {
        queryString = inputValue.toLowerCase();
        renderPB = true;
        pageBlockSize = 10;
        if(pageNumber == null)
        {
            pageNumber = 1;
        }
        try
        {
            if(queryString.contains('limit'))
            {
                throw new LimitException('Limit exist');
            }
            if(queryString.contains('order'))
            {
                throw new OrderByException('Order by exist');
            }
            countLstObjs = Database.query(queryString);
            totalRecs = countLstObjs.size();
            if(totalRecs <= 0)
            {
                renderPB = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No records found'));
            }
            else
            {
                lstFlds = new List<String>();
                if(sortExp != null && sortDirection != null)
                {
                    sortFullExp = sortExp  + ' ' + sortDirection;
                    queryString = queryString + ' ORDER BY ' + sortFullExp + ' LIMIT ' + pageBlockSize + ' OFFSET ' + index;
                    lstObjs = Database.query(queryString);
                }
                else
                {
                    queryString = queryString + ' LIMIT ' + pageBlockSize + ' OFFSET ' + index;
                    lstObjs = Database.query(queryString);    
                }
                lstObjs = Database.query(queryString);
                fieldsName = queryString.substring(7, queryString.indexOf(' from'));
                fieldsName = fieldsName.remove(' ');
                lstFlds = fieldsName.split(',');
            }
        }
        catch(QueryException e)
        {
            renderPB = false;
            pageNumber = 1;
            index = 0;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter the correct query'));
        }
        catch(LimitException e)
        {
            renderPB = false;
            pageNumber = 1;
            index = 0;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Limit functionality does not exist'));
        }
        catch(OrderByException e)
        {
            renderPB = false;
            pageNumber = 1;
            index = 0;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Order By functionality does not exist'));
        }
    }
    public String getqueryString() 
    {
        return queryString;
    } 
    public PageReference viewData() 
    {
        return null;
    }
    // Code for pagination
    public void beginning() 
    {  
        index = 0;  
        pageNumber = 1;
    }  
    public void previous() 
    {  
        pageNumber--;
        index = index - pageBlockSize;  
    }  
    public void next() 
    {  
        pageNumber++;
        index = index + pageBlockSize;  
    }  
    public void end() 
    {  
        pageNumber = (totalrecs / pageBlockSize) + 1; 
        if (math.mod(totalrecs, pageBlockSize) == 0)
        {
            pageNumber = pageNumber - 1;
        }
        index = totalrecs - math.mod(totalRecs, pageBlockSize);  
    } 
    public boolean getPrev() 
    {  
        if(index == 0)  
            return true;  
        else  
            return false;  
    }    
    public boolean getNxt() 
    {  
        if((index + pageBlockSize) > totalRecs)  
            return true;  
        else  
            return false;  
    }
    public PageReference goToPageNumber()
    {
        if(inputPageNumber <= ((totalRecs / pageBlockSize) + 1))
        {
            index = pageBlockSize * (inputPageNumber - 1);
            pageNumber = inputPageNumber;
        }	
        return null;
    }
}