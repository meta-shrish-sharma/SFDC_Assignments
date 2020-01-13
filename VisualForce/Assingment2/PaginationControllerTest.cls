@isTest
public class PaginationControllerTest 
{
    @testSetup 
    static void setup() 
    {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCity = 'Jaipur';
        acc.BillingCountry = 'India'; 
        acc.BillingState =  'Rajasthan';
        insert acc;    
    }
    @isTest 
    static void testAccountFilter_matchCity_getCityRecords() 
    {
        PaginationController pgController = new  PaginationController();
        pgController.inputBillingCity = 'Jaipur';
        System.assertEquals(1, pgController.getAccounts().size());
    }
    @isTest
    static void testAccountFilter_matchState_getStateRecords() 
    {
        PaginationController pgController = new  PaginationController();
        pgController.inputBillingState = 'Rajasthan';
        System.assertEquals(1, pgController.getAccounts().size());
    }
    @isTest
    static void testAccountFilter_matchCountry_getCountryRecords() 
    {
        PaginationController pgController = new  PaginationController();
        pgController.inputBillingCountry = 'India';
        System.assertEquals(1, pgController.getAccounts().size());
    }
    @isTest
    static void testAccountFilter_matchAll_getMatchingRecords() 
    {
        PaginationController pgController = new  PaginationController();
        pgController.inputBillingCountry = 'India';
        pgController.inputBillingState = 'Rajasthan';
        pgController.inputBillingCity = 'Jaipur';
        System.assertEquals(1, pgController.getAccounts().size());
    }
}