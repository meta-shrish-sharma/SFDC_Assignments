@isTest
public class ShoppingCartControllerTest
{
    @testSetup 
    static void setup() 
    {
        List<PurchaseOrder__c> purchaseOrderList = new List<PurchaseOrder__c>();
        for(Integer orderCount = 0; orderCount < 20; orderCount++)
        {
            purchaseOrderList.add(new PurchaseOrder__c (Name = 'Test Order ' + orderCount, OrderPrice__c = 100 * orderCount, User__c = UserInfo.getUserId()));
        }
        insert purchaseOrderList;
        List<Product2> prdList = new List<Product2>();
        for(Integer prdCount = 0; prdCount < 20; prdCount++)
        {
            prdList.add(new Product2 (Name = 'Test Product ' + prdCount, QuantityAvilable__c = prdCount, ProductPrice__c = 100 * prdCount));
        }
        insert prdList;
    }
    @isTest
    static void testShoppingCartControllerTest_orderDetails_getOrderHistorySize()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        System.assertEquals(20, cartController.setOrder.getResultSize());
    }
    @isTest
    static void testShoppingCartControllerTest_orderDetailsPagination_runPagination()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        // Test page size
        System.assertEquals(10, cartController.setOrder.getPageSize());
        // Test has previous
        System.assertEquals(false, cartController.setOrder.getHasPrevious());
        // Test has next
        System.assertEquals(true, cartController.setOrder.getHasNext());
        // Pagination with sorting
        cartController.sortExpression = 'OrderPrice__c';
        List<Purchaseorder__c> pOrder = cartController.getAllOrders();
        // Only 1 to 10 orders will be featched and first has 0 proce
        System.assertEquals(0, pOrder[0].OrderPrice__c);
        // Go to next page
        cartController.setOrder.next();
        pOrder = cartController.getAllOrders();
        System.assertEquals(1000, pOrder[0].OrderPrice__c);
        // Go to previous page
        cartController.setOrder.previous();
        pOrder = cartController.getAllOrders();
        System.assertEquals(0, pOrder[0].OrderPrice__c);
        // Go to end page
        cartController.setOrder.last();
        pOrder = cartController.getAllOrders();
        System.assertEquals(1000, pOrder[0].OrderPrice__c);
        // Go to first page
        cartController.setOrder.first();
        pOrder = cartController.getAllOrders();
        System.assertEquals(0, pOrder[0].OrderPrice__c);
    }
    @isTest
    static void testShoppingCartControllerTest_orderDetailsSorting_getSortedOrderDetails()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        // Sort in ASC 
        cartController.sortExpression = 'OrderPrice__c';
        cartController.refreshOrders();
        List<Purchaseorder__c> pOrder = cartController.getAllOrders();
        // Minumum price at top
        System.assertEquals(0, pOrder[0].OrderPrice__c);
        // Sort in DESC
        cartController.sortExpression = 'OrderPrice__c';
        cartController.refreshOrders();
        pOrder = cartController.getAllOrders();
        // Maximum price at top
        System.assertEquals(100 * (cartController.setOrder.getResultSize() - 1), pOrder[0].OrderPrice__c);
    }
    @isTest
    static void testShoppingCartControllerTest_showProducts_showProductTable()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        System.assertEquals(false, cartController.getHideshow());
        cartController.showProducts();
        System.assertEquals(true, cartController.getHideshow());
    }
    @isTest
    static void testShoppingCartControllerTest_allProducts_getAllProducts()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        cartController.setHideshow(true);
        Map<Id, Product2WrapperCls> prdMap = cartController.getAllProducts();
        System.assertEquals(20, cartController.totalRecs);
    }
    @isTest
    static void testShoppingCartControllerTest_searchProducts_getSearchedProducts()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        cartController.searchProduct = '2';
        Map<Id, Product2WrapperCls> prdMap = cartController.getAllProducts();
        // Product with name Test Product 2 and Test Product 12
        System.assertEquals(2, cartController.totalRecs);
    }
    @isTest
    static void testShoppingCartControllerTest_productsPagination_runPagination()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        // Test has previous
        System.assertEquals(true, cartController.getprev());
        // Test has next
        System.assertEquals(false, cartController.getnxt());
        // Go to next page
        cartController.next();
        System.assertEquals(2, cartController.pageNumber);
        // Go to previous page
        cartController.previous();
        System.assertEquals(1, cartController.pageNumber);
        // Go to end page
        cartController.end();
        System.assertEquals(2, cartController.pageNumber);
        // Test has previous
        System.assertEquals(false, cartController.getprev());
        // Test has next
        System.assertEquals(true, cartController.getnxt());
        // Go to first page
        cartController.beginning();
        System.assertEquals(1, cartController.pageNumber);
    }
    @isTest
    static void testShoppingCartControllerTest_zeroQtyProduct_failedToAddToCart()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        Map<Id, Product2WrapperCls> prdMap = cartController.getAllProducts();
        Id prd1Id = [SELECT Id FROM Product2 WHERE Name = 'Test Product 0'].Id;
        prdMap.get(prd1Id).isSelected = true;
        cartController.addToCart();
        System.assertEquals(0, cartController.selectedProducts.size());
    }
    @isTest
    static void testShoppingCartControllerTest_cart_addToCart()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        Map<Id, Product2WrapperCls> prdMap = cartController.getAllProducts();
        Id prd1Id = [SELECT Id FROM Product2 WHERE Name = 'Test Product 2'].Id;
        Id prd2Id = [SELECT Id FROM Product2 WHERE Name = 'Test Product 3'].Id;
        Integer totalProducts;
        prdMap.get(prd1Id).isSelected = true;
        prdMap.get(prd2Id).isSelected = true;
        // Add Products to cart
        cartController.addToCart();
        System.assertEquals(2, cartController.selectedProducts.size());
        // Add same products to cart
        cartController.addToCart();
        System.assertEquals(2, cartController.selectedProducts.size());
        // Cart should get visible
        System.assertEquals(true, cartController.getShowCartList());
        totalProducts = cartController.selectedProducts.get(prd1Id).prdCount + cartController.selectedProducts.get(prd2Id).prdCount;
        // Products count should get doubled
        System.assertEquals(4, totalProducts);
        // Product should get decreased in product table
        System.assertEquals(0, prdMap.get(prd1Id).cProduct.QuantityAvilable__c);
        // Checkout button will become enable
        System.assert(!cartController.checkoutDisable);
    }
    @isTest
    static void testShoppingCartControllerTest_cart_deleteFromCart()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        Map<Id, Product2WrapperCls> prdMap = cartController.getAllProducts();
        Id prd1Id = [SELECT Id FROM Product2 WHERE Name = 'Test Product 2'].Id;
        Id prd2Id = [SELECT Id FROM Product2 WHERE Name = 'Test Product 3'].Id;
        Integer totalProducts;
        prdMap.get(prd1Id).isSelected = true;
        prdMap.get(prd2Id).isSelected = true;
        // Add Products to cart
        cartController.addToCart();
        // Set Id to delete
        cartController.cartSelectPrdId = prd1Id;
        cartController.deleteRow();
        System.assertEquals(null, cartController.selectedProducts.get(prd1Id));
        // Delete all products cart should get invisible
        cartController.cartSelectPrdId = prd2Id;
        cartController.deleteRow();
        System.assertEquals(false, cartController.getShowCartList());
    }
    @isTest
    static void testShoppingCartControllerTest_validateCartProducts_getErrorMessage()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        Map<Id, Product2WrapperCls> prdMap = cartController.getAllProducts();
        Id prd1Id = [SELECT Id FROM Product2 WHERE Name = 'Test Product 2'].Id;
        Id prd2Id = [SELECT Id FROM Product2 WHERE Name = 'Test Product 3'].Id;
        Integer totalProducts;
        prdMap.get(prd1Id).isSelected = true;
        prdMap.get(prd2Id).isSelected = true;
        // Add Products to cart
        cartController.addToCart();
        // Set Id to for change in product count
        cartController.cartSelectPrdId = prd1Id;
        // Test with negative value
        cartController.selectedProducts.get(prd1Id).prdCount = -1;
        cartController.handleUpdateChange();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean foundErrorMessage = false;
        for(Apexpages.Message msg:msgs)
        {
            if (msg.getDetail().contains('Qty cannot be negative')) 
                foundErrorMessage = true;
        }
        system.assert(foundErrorMessage);
        // Checkout button will remain disable
        System.assert(cartController.checkoutDisable);
        // Test with zero value
        cartController.selectedProducts.get(prd1Id).prdCount = 0;
        cartController.handleUpdateChange();
        msgs = ApexPages.getMessages();
        foundErrorMessage = false;
        for(Apexpages.Message msg:msgs)
        {
            if (msg.getDetail().contains('Qty cannot be Zero')) 
                foundErrorMessage = true;
        }
        system.assert(foundErrorMessage);
        // Test with more then available value
        cartController.selectedProducts.get(prd1Id).prdCount = 3;
        cartController.handleUpdateChange();
        msgs = ApexPages.getMessages();
        foundErrorMessage = false;
        for(Apexpages.Message msg:msgs)
        {
            if (msg.getDetail().contains('Qty cannot be more then 2')) 
                foundErrorMessage = true;
        }
        system.assert(foundErrorMessage);
    }
    @isTest
    static void testShoppingCartControllerTest_updateCart_updateProductCount()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        Map<Id, Product2WrapperCls> prdMap = cartController.getAllProducts();
        Id prd1Id = [SELECT Id FROM Product2 WHERE Name = 'Test Product 2'].Id;
        Id prd2Id = [SELECT Id FROM Product2 WHERE Name = 'Test Product 3'].Id;
        Integer totalProducts;
        prdMap.get(prd1Id).isSelected = true;
        prdMap.get(prd2Id).isSelected = true;
        // Add Products to cart
        cartController.addToCart();
        // Set Id to for change in product count
        cartController.cartSelectPrdId = prd1Id;
        // Test with negative value
        cartController.selectedProducts.get(prd1Id).prdCount = 2;
        cartController.handleUpdateChange();
        // Update product list
        cartController.refresh();
        prdMap = cartController.getAllProducts();
        // Product table should get updates
        System.assertEquals(0, prdMap.get(prd1Id).cProduct.QuantityAvilable__c);
        // Checkout button will become enable
        System.assert(!cartController.checkoutDisable);
    }
    @isTest
    static void testShoppingCartControllerTest_checkoutCart_successfulCheckoutProductCart()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        Map<Id, Product2WrapperCls> prdMap = cartController.getAllProducts();
        Id prd1Id = [SELECT Id FROM Product2 WHERE Name = 'Test Product 2'].Id;
        Id prd2Id = [SELECT Id FROM Product2 WHERE Name = 'Test Product 3'].Id;
        Integer totalProducts;
        prdMap.get(prd1Id).isSelected = true;
        prdMap.get(prd2Id).isSelected = true;
        // Add Products to cart
        cartController.addToCart();
        cartController.checkout();
        System.assertEquals(500, cartController.orderTotal);
        System.assertEquals(true, cartController.renderOrderDetails);
    }
    @isTest
    static void testShoppingCartControllerTest_placeOrder_successfulPlaceOrder()
    {
        ShoppingCartController cartController = new ShoppingCartController();
        Map<Id, Product2WrapperCls> prdMap = cartController.getAllProducts();
        Id prd1Id = [SELECT Id FROM Product2 WHERE Name = 'Test Product 2'].Id;
        Id prd2Id = [SELECT Id FROM Product2 WHERE Name = 'Test Product 3'].Id;
        Integer totalProducts;
        prdMap.get(prd1Id).isSelected = true;
        prdMap.get(prd2Id).isSelected = true;
        // Add Products to cart
        cartController.addToCart();
        cartController.checkout();
        cartController.placeOrder();
        List<Purchaseorder__c> pOrderList= [SELECT Id, Name FROM Purchaseorder__c WHERE OrderNumber__c = :cartController.randomOrderNumber];
        System.assertEquals(1, pOrderList.size());
    }
}
