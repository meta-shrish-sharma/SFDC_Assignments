public class Product2WrapperCls 
{
    public Boolean isSelected{get;set;}
    public Product2 cProduct{get;set;}
    public Product2WrapperCls(Product2 cProduct)
    {
        this.cProduct = cProduct;
        this.isSelected = false;      
    }
}