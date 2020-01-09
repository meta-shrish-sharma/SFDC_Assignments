public class ShoppingCartController 
{
    // this varibales value is used for searching product. Value is taken from search box labeled product name.
    // the value is further appended with SOQL query with where condition to sesrch the products
    public String searchProduct{get;set;}
    //List of all the products needs to be displayed in pageBlockTable in beginning from the search query
    private List<Product2> prdList;
    //List of all orders placed by current login user in past
    public List<Purchaseorder__c> ordrList{get;set;}
    // Total no of orders available in purchase history
    public Integer noOfOrders{get;set;}
    //For pagination of order table, Purchase order history table size
    public Integer orderPagesize{get;set;}
    //Search query to get the products with applying all filters also
    private String searchQuery;
    //Products needs to be added to cart after selecting from product list
    public List<CartWrapperCls> selectedProducts{get;set;}
    //products list with wrapper class with checkboxes
    public List<Product2WrapperCls> prdListTable{get;set;}
    private Boolean showProdList = false;
    private Boolean showCartList = false;
    //used to view cart only when products are added button
    public Boolean renderOrderDetails{get;set;}
    //used to enable checkout button
    public Boolean checkoutDisable{get;set;}
    //to create a random number for order details
    public Integer randomOrderNumber{get;set;}
    //total amount of all products in cart
    public Decimal orderTotal{get;set;}
    // ** Variables for pagination of Products
    public Integer totalRecs{get;set;}
    private Integer totalRecsWithoutSearch;
    private Integer index = 0;  
    private Integer blockSize = 10;
    public Integer pageBlockSize{get;set;}
    public Integer pageNumber{get;set;}
    // **
    public ShoppingCartController()
    {
        pageBlockSize = 10;
        pageNumber = 1;
        selectedProducts = new List<CartWrapperCls>();
        getAllProducts();
        checkoutDisable = true;
        renderOrderDetails = false;
        randomOrderNumber = Integer.valueof((Math.random() * 1000000));
        totalRecs = [SELECT COUNT() FROM Product2];
        totalRecsWithoutSearch = totalRecs;
    }
    //**This section is for Purchase History detail**
    public List<Purchaseorder__c> getAllOrders()
    {
        List<Purchaseorder__c> ordListTable = new List<Purchaseorder__c>();
        for(Purchaseorder__c order : (List<Purchaseorder__c>)setOrder.getRecords()) // Data should be fetched from setCon to form the data in pages
            ordListTable.add(order);
        return ordListTable;
    }
    public ApexPages.StandardSetController setOrder 
    {
        get{
            if(setOrder == null){
                string ordSearchQuery = 'SELECT Id, OrderPrice__c, Orderstatus__c FROM Purchaseorder__c';        
                ordrList = Database.query(ordSearchQuery);
                setOrder = new ApexPages.StandardSetController(ordrList);
                orderPagesize = 10;
                setOrder.setPageSize(orderPagesize);
                noOfOrders = setOrder.getResultSize();
            }
            return setOrder;
        }set;
    }
    //**This section is for Product detail**
    public pageReference showProducts() //to refresh the page block after taking input for search box
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
    public List<Product2WrapperCls> getAllProducts()
    {
        prdListTable = new List<Product2WrapperCls>();
        //This map is used to exclude the number of products already added in cart
        Map<Id, Integer> cartMap = new Map<Id, Integer>();
        if(selectedProducts.size() > 0)
        {
            for(CartWrapperCls cartProdCount : selectedProducts)
            {
                cartMap.put(cartProdCount.cProduct.id, cartProdCount.prdCount);
            }
        }
        if(searchProduct == null || searchProduct == '')
        {
            searchQuery='SELECT Id, Name, ProductCode, Description, ProductPrice__c, QuantityAvilable__c FROM Product2 LIMIT ' + pageBlockSize + ' OFFSET ' + index;
            prdList = Database.query(searchQuery);
            totalRecs = totalRecsWithoutSearch; // Updation required after search operation
        }
        else //if serching is not yet applied it will take all the products by default
        {
            searchQuery='SELECT Id, Name, ProductCode, Description, ProductPrice__c, QuantityAvilable__c FROM Product2 WHERE Name LIKE \'%' + searchProduct + '%\' ORDER BY Name LIMIT ' + pageBlockSize + ' OFFSET ' + index;
            prdList = Database.query(searchQuery);
            totalRecs = prdList.size(); // Updation required after search operation
        }
        for(Product2 prd : prdList)
        {	
            if((selectedProducts.size() > 0) && (cartMap.get(prd.Id) > 0))
            {
                prd.QuantityAvilable__c = prd.QuantityAvilable__c - cartMap.get(prd.Id);
            }
            prdListTable.add(new Product2WrapperCls(prd));
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
    public pageReference refresh() //to refresh the page block after taking input for search box
    {
        getAllProducts();
        return null;
    }
    //**This section is for Cart detail**
    public pageReference AddToCart() // To add the products in cart table
    {	
        Integer selected = 0;
        Integer notselected = 0;
        for(Product2WrapperCls cWrapper : prdListTable)
        {
            if(cWrapper.isSelected == true)
            {
                boolean availableInCart = false;
                //Quantity of product os picklist in standerd object
                //hence needs to be converted first
                if(cWrapper.cProduct.QuantityAvilable__c > 0)
                {
                    checkoutDisable = false;
                    setShowCartList(true);
                    cWrapper.cProduct.QuantityAvilable__c--; 
                    // converting to string before saving to
                    // the standerd product object
                    // verify that product is avilable in cart or not
                    // if avilalable then increment the available number of product in cart   
                    for(CartWrapperCls crtWrap: selectedProducts)
                    {
                        if (crtWrap.cProduct.id == cWrapper.cProduct.id)
                        {
                            crtWrap.prdCount++;
                            availableInCart = true;
                        }
                    }
                    //if product is not avilable in list then add the product in list   
                    if(!availableInCart)
                        selectedProducts.add(new CartWrapperCls(cWrapper.cProduct,1));
                }
            }
        }//All products are added in map
        return null;
    }
    public Pagereference deleteRow()
    {
        String SelectedRowId=ApexPages.CurrentPage().getParameters().get('rowid');
        Integer crtListIndex = 0;
        while(crtListIndex < selectedProducts.size())
        {
            if(selectedProducts.get(crtListIndex).cProduct.id == SelectedRowId)
            {
                for(Product2WrapperCls cWrapper : prdListTable)
                {
                    if(cWrapper.cProduct.id == SelectedRowId)
                    {
                        cWrapper.cProduct.QuantityAvilable__c = cWrapper.cProduct.QuantityAvilable__c + selectedProducts.get(crtListIndex).prdCount;
                    }
                }
                selectedProducts.remove(crtListIndex);
            }
            else
            {
                crtListIndex++;
            }
        }
        if(selectedProducts.size() == 0)
        {
            setShowCartList(false);  
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
    //**This section is to validate Cart Items **
    public Pagereference handleUpdateChange()
    {
        ID objSelectedPrdID=ApexPages.CurrentPage().getParameters().get('updVal');
        for(CartWrapperCls wrp:selectedProducts)
        {
            Decimal maxPrdCount = [SELECT QuantityAvilable__c FROM Product2 WHERE Id = :objSelectedPrdID][0].QuantityAvilable__c;
            //validate the value of inputbox.
            if(wrp.cProduct.id == objSelectedPrdID)
            {
                checkoutDisable = false;	
                if(wrp.prdCount < 0)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Qty cannot be negative for '+wrp.cProduct.Name ));
                    checkoutDisable = true;	
                }
                if(wrp.prdCount > maxprdCount)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Qty cannot be more then '+ maxprdCount +' for '+wrp.cProduct.Name ));
                    checkoutDisable = true;
                }
                if(wrp.prdCount == 0)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Qty cannot be Zero for '+wrp.cProduct.Name ));
                    checkoutDisable = true;	
                }
                //updating the product detail table
                for(Product2WrapperCls cWrapper : prdListTable)
                {
                    if(cWrapper.cProduct.id == objSelectedPrdID)
                    {
                        cWrapper.cProduct.QuantityAvilable__c = maxprdCount - wrp.prdCount + 1;
                    }
                }             
                break;
            }
        }
        return null;
    }
    public pageReference Checkout() // To add the products in cart table
    {	
        Decimal totalSum = 0;
        for(CartWrapperCls wrp:selectedProducts)
        {
            if(wrp.cProduct.ProductPrice__c != null)
                totalSum = totalSum + (wrp.cProduct.ProductPrice__c * wrp.prdCount);
        }
        orderTotal = totalSum;
        renderOrderDetails = true;
        return null;
    }
    public pageReference placeOrder() // To add the products in cart table
    {	
        Purchaseorder__c ordr = new Purchaseorder__c();
        ordr.OrderNumber__c = randomOrderNumber;
        ordr.OrderPlaceTime__c = system.Now();
        ordr.OrderPrice__c = orderTotal;
        ordr.OrderStatus__c = 'Pending';
        ordr.User__c = UserInfo.getUserId();
        upsert ordr;
        List<PurchaseOrderLineItems__c> orderLineList = new  List<PurchaseOrderLineItems__c>();
        for(CartWrapperCls wrp:selectedProducts)
        {
            PurchaseOrderLineItems__c POL = new PurchaseOrderLineItems__c();
            POL.Product__c = wrp.cProduct.id;
            POL.ProductQuantity__c = wrp.prdCount;
            POL.PurchaseOrder__c = ordr.Id;
            POL.Name = wrp.cProduct.Name+'Order';
            orderLineList.add(POL);
        }
        upsert orderLineList;
        PageReference currentPage = new pageReference('/apex/OrderHistory');
        currentPage.setRedirect(true);
        return currentPage ;
    }
}