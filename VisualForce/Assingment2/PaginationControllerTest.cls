@isTest
public class PaginationControllerTest 
{
    @testSetup 
    static void setup() 
    {
        List<Account> accList = new List<Account>();
        for(Integer accountCounter = 0; accountCounter < 4; accountCounter++)
        {
            Account acc = new Account();
            acc.Name = 'Test Account ' + accountCounter;
            acc.BillingCity = 'Test City ' + accountCounter;
            acc.BillingCountry = 'Test Country ' + accountCounter; 
            acc.BillingState =  'Test State ' + accountCounter;
            accList.add(acc);
        }
        insert accList;    
    }
    @isTest 
    static void testAccountFilter_matchCity_getCityRecords() 
    {
        PaginationController pgController = new  PaginationController();
        pgController.inputBillingCity = 'Test City 0';
        System.assertEquals(1, pgController.getAccounts().size());
    }
    @isTest
    static void testAccountFilter_matchState_zeroRecord() 
    {
        PaginationController pgController = new  PaginationController();
        pgController.inputBillingState = 'Test State';
        System.assertNotEquals(1, pgController.getAccounts().size());
    }
    @isTest
    static void testAccountFilter_matchCountry_getCountryRecords() 
    {
        PaginationController pgController = new  PaginationController();
        pgController.inputBillingCountry = 'Test Country 2';
        System.assertEquals(1, pgController.getAccounts().size());
    }
    @isTest
    static void testAccountFilter_matchAll_getMatchingRecords() 
    {
        PaginationController pgController = new  PaginationController();
        pgController.inputBillingCountry = 'Test Country 1';
        pgController.inputBillingState = 'Test State 1';
        pgController.inputBillingCity = 'Test City 1';
        System.assertEquals(1, pgController.getAccounts().size());
    }
    @isTest
    static void testAccountFilter_pageSize_getPageSize() 
    {
        PaginationController pgController = new  PaginationController();
        pgController.inputTotalNoOfRecords = 2;
        pgController.refresh();
        System.assertEquals(2, pgController.setCon.getPageSize());
    }
}
