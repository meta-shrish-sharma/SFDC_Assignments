public class ShoppingCartController 
{
    /* This variable is used for searching product. Value is taken from search box labeled product name.
	The value is further appended with SOQL query with where condition to search the products */
    public String searchProduct{get;set;}
    // List of all the products needs to be displayed in pageBlockTable in beginning with searching
    private List<Product2> prdList;
    // List of all orders placed by current login user in past
    public List<Purchaseorder__c> ordrList{get;set;}
    // Total no of orders available in purchase history
    public Integer noOfOrders{get;set;}
    // For pagination of order table, Purchase order history table size
    public Integer orderPagesize{get;set;}
    // Varibles for sorting of order history
    public String sortDirection{get;set;}
    private String sortExp;
    public String sortExpression 
    {
        get
        {
            return sortExp;
        }
        set
        {
            // If the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
            setOrder = null;
        }
    }
    // Search query to get the products with applying all filters also
    private String searchQuery;
    // Products needs to be added to cart after selecting from product list
    public Map<Id, CartWrapperCls> selectedProducts{get;set;}
    // For update delete operation in cart
    public Id cartSelectPrdId{get;set;}
    // Products list with wrapper class with checkboxes
    public Map<Id, Product2WrapperCls> prdListTable{get;set;}
    private Boolean showProdList = false;
    private Boolean showCartList = false;
    // Rendring the cart only when products are added button
    public Boolean renderOrderDetails{get;set;}
    // Disable the checkout if cart is empty or data is not correct
    public Boolean checkoutDisable{get;set;}
    // Create a random varible for order number
    public Integer randomOrderNumber{get;set;}
    // Grand total of cart products
    public Decimal orderTotal{get;set;}
    // Variables for pagination of Products
    public Integer totalRecs{get;set;}
    private Integer totalRecsWithoutSearch;
    private Integer index = 0;  
    private Integer blockSize = 10;
    public Integer pageBlockSize{get;set;}
    public Integer pageNumber{get;set;}
    public ShoppingCartController()
    {
        pageBlockSize = 10;
        pageNumber = 1;
        selectedProducts = new Map<Id, CartWrapperCls>();
        getAllProducts();
        checkoutDisable = true;
        renderOrderDetails = false;
        randomOrderNumber = Integer.valueof((Math.random() * 1000000));
        totalRecs = [SELECT COUNT() FROM Product2];
        totalRecsWithoutSearch = totalRecs;
    }
    // Below code is for Purchase History detail
    public List<Purchaseorder__c> getAllOrders()
    {
        List<Purchaseorder__c> ordListTable = new List<Purchaseorder__c>();
        for(Purchaseorder__c order: (List<Purchaseorder__c>)setOrder.getRecords()) // Data should be fetched from setCon to form the data in pages
            ordListTable.add(order);
        return ordListTable;
    }
    public ApexPages.StandardSetController setOrder 
    {
        get
        {
            if(setOrder == null)
            {
                String ordSearchQuery;
                if(sortExp == null)
                {
                    ordSearchQuery = 'SELECT Id, OrderPrice__c, Orderstatus__c FROM Purchaseorder__c WHERE User__c = \'' + UserInfo.getUserId() + '\'';  
                }
                else
                {
                    String sortFullExp = sortExp  + ' ' + sortDirection;
                    ordSearchQuery = 'SELECT Id, OrderPrice__c, Orderstatus__c FROM Purchaseorder__c ' + 'WHERE User__c = \'' + UserInfo.getUserId() + '\' ORDER BY ' + sortFullExp;  
                }
                ordrList = Database.query(ordSearchQuery);
                setOrder = new ApexPages.StandardSetController(ordrList);
                orderPagesize = 10;
                setOrder.setPageSize(orderPagesize);
                noOfOrders = setOrder.getResultSize();
            }
            return setOrder;
        }set;
    }
    public pageReference refreshOrders() // Refresh the page block after taking input for search box
    {
        getAllOrders();
        return null;
    }
    // This section is for Product detail 
    public pageReference showProducts()
    {
        setHideshow(true);  
        return null;
    }
    public Boolean getHideshow()
    {
        return this.showProdList;
    }
    public void setHideshow(boolean s)
    {
        this.showProdList = s;
    }
    public Map<Id, Product2WrapperCls> getAllProducts()
    {
        prdListTable = new Map<Id, Product2WrapperCls>();
        if(String.isBlank(searchProduct))// If serching is not yet applied it will take all the products by default
        {
            searchQuery='SELECT Id, Name, ProductCode, Description, ProductPrice__c, QuantityAvilable__c FROM Product2 LIMIT ' + pageBlockSize + ' OFFSET ' + index;
            prdList = Database.query(searchQuery);
            totalRecs = totalRecsWithoutSearch; // Updating total records after search operation
        }
        else 
        {
            searchQuery='SELECT Id, Name, ProductCode, Description, ProductPrice__c, QuantityAvilable__c FROM Product2 WHERE Name LIKE \'%' + searchProduct + '%\' ORDER BY Name LIMIT ' + pageBlockSize + ' OFFSET ' + index;
            prdList = Database.query(searchQuery);
            totalRecs = prdList.size(); // Updation required after search operation
        }
        for(Product2 prd: prdList)
        {	
            if(selectedProducts.get(prd.Id) != null)
            {
                if(selectedProducts.get(prd.Id).prdCount > 0)
                {
                    prd.QuantityAvilable__c = prd.QuantityAvilable__c - selectedProducts.get(prd.Id).prdCount;
                }
            }
            prdListTable.put(prd.Id, new Product2WrapperCls(prd));
        }
        return prdListTable;
    }
    public void beginning() 
    {  
        index = 0;  
        pageNumber = 1;
        getAllProducts();   
    }  
    public void previous() 
    {  
        pageNumber--;
        index = index - pageBlockSize;  
        getAllProducts();
    }  
    public void next() 
    {  
        pageNumber++;
        index = index + pageBlockSize;  
        getAllProducts();
    }  
    public void end() 
    {  
        pageNumber = (totalrecs / pageBlockSize) + 1; 
        if (math.mod(totalrecs, pageBlockSize) == 0)
        {
            pageNumber = pageNumber - 1;
        }
        index = totalrecs - math.mod(totalRecs, pageBlockSize);  
        getAllProducts();
    } 
    public boolean getprev() 
    {  
        if(index == 0)  
            return true;  
        else  
            return false;  
    }    
    public boolean getnxt() 
    {  
        if((index + pageBlockSize) > totalRecs)  
            return true;  
        else  
            return false;  
    }  
    public pageReference refresh()
    {
        getAllProducts();
        return null;
    }
    // This section is for Cart detail 
    public pageReference addToCart() // To add the products in cart table
    {	
        Integer selected = 0;
        Integer notselected = 0;
        for(Id cWrapper: prdListTable.keySet())
        {
            if((prdListTable.get(cWrapper).isSelected == true) && (prdListTable.get(cWrapper).cProduct.QuantityAvilable__c > 0))
            {
                boolean availableInCart = false;
                checkoutDisable = false;
                setShowCartList(true);
                prdListTable.get(cWrapper).cProduct.QuantityAvilable__c--; 
                /*  verify that product is avilable in cart or not
                    if avilalable then increment the available number of product in cart*/   
                if(selectedProducts.get(prdListTable.get(cWrapper).cProduct.Id) != null)
                {
                    selectedProducts.get(prdListTable.get(cWrapper).cProduct.Id).prdCount++;
                }
                else
                {
                    selectedProducts.put(prdListTable.get(cWrapper).cProduct.Id, new CartWrapperCls(prdListTable.get(cWrapper).cProduct, 1));
                }
            }
        }// All selected products are added in map
        return null;
    }
    public Pagereference deleteRow()
    {
        if(selectedProducts.get(cartSelectPrdId) != null)
        {
            if(selectedProducts.get(cartSelectPrdId).prdCount > 0)
            {
                prdListTable.get(cartSelectPrdId).cProduct.QuantityAvilable__c = prdListTable.get(cartSelectPrdId).cProduct.QuantityAvilable__c + selectedProducts.get(cartSelectPrdId).prdCount;
            }
            prdListTable.remove(cartSelectPrdId);
            selectedProducts.remove(cartSelectPrdId);
            if(selectedProducts.size() == 0)
            {
                setShowCartList(false);  
            }
        }
        return null;
    }
    public Boolean getShowCartList()
    {
        return this.showCartList;
    }
    public void setShowCartList(boolean showValue)
    {
        this.showCartList = showValue;
    }
    // Below code section is to validate Cart Items 
    public Pagereference handleUpdateChange()
    {
        Decimal maxPrdCount = [SELECT QuantityAvilable__c FROM Product2 WHERE Id = :cartSelectPrdId][0].QuantityAvilable__c;
        checkoutDisable = false;
        if(selectedProducts.get(cartSelectPrdId) != null)
        {
            if(selectedProducts.get(cartSelectPrdId).prdCount < 0)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Qty cannot be negative for ' + selectedProducts.get(cartSelectPrdId).cProduct.Name ));
                checkoutDisable = true;	
            }
            if(selectedProducts.get(cartSelectPrdId).prdCount > maxPrdCount)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Qty cannot be more then ' + maxPrdCount + ' for ' + selectedProducts.get(cartSelectPrdId).cProduct.Name));
                checkoutDisable = true;
            }
            if(selectedProducts.get(cartSelectPrdId).prdCount == 0)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Qty cannot be Zero for ' + selectedProducts.get(cartSelectPrdId).cProduct.Name ));
                checkoutDisable = true;	
            }
            // Updating the product detail table
            if(checkoutDisable == false)
            {
                prdListTable.get(cartSelectPrdId).cProduct.QuantityAvilable__c = maxPrdCount - selectedProducts.get(cartSelectPrdId).prdCount + 1;
            }
            else
            {
                prdListTable.get(cartSelectPrdId).cProduct.QuantityAvilable__c = maxPrdCount;
            }
        }
        return null;
    }
    public pageReference checkout()
    {	
        Decimal totalSum = 0;
        for(Id cartProducts: selectedProducts.keySet())
        {
            if(selectedProducts.get(cartProducts) != null)
                totalSum = totalSum + (selectedProducts.get(cartProducts).cProduct.ProductPrice__c * selectedProducts.get(cartProducts).prdCount);
        }
        orderTotal = totalSum;
        renderOrderDetails = true;
        return null;
    }
    public pageReference placeOrder()
    {	
        Purchaseorder__c ord = new Purchaseorder__c();
        ord.OrderNumber__c = randomOrderNumber;
        ord.OrderPlaceTime__c = System.Now();
        ord.OrderPrice__c = orderTotal;
        ord.OrderStatus__c = 'Pending';
        ord.User__c = UserInfo.getUserId();
        upsert ord;
        List<PurchaseOrderLineItems__c> orderLineList = new  List<PurchaseOrderLineItems__c>();
        for(Id cartProducts: selectedProducts.keySet())
        {
            PurchaseOrderLineItems__c POL = new PurchaseOrderLineItems__c();
            POL.Product__c = selectedProducts.get(cartProducts).cProduct.Id;
            POL.ProductQuantity__c = selectedProducts.get(cartProducts).prdCount;
            POL.PurchaseOrder__c = ord.Id;
            POL.Name = selectedProducts.get(cartProducts).cProduct.Name + ' Order';
            orderLineList.add(POL);
        }
        upsert orderLineList;
        PageReference currentPage = new pageReference('/apex/OrderHistory');
        currentPage.setRedirect(true);
        return currentPage;
    }
}