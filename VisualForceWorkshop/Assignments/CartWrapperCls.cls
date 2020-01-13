public class CartWrapperCls 
{
    public Integer prdCount{get;set;}
    public Product2 cProduct{get;set;}
    public CartWrapperCls(Product2 cProduct, integer prdCnt)
    {
        this.cProduct = cProduct;
        this.prdCount = prdCnt;      
    }
}