public class facebookerror
{
    public facebookerror()
    {
        
    }
    public PageReference setredirect()
    {
        Pagereference ps=new Pagereference('/apex/socialsetup');
       //  System.Debug(MBT_SFFB.facebook_API.gotAccessTocken((ApexPages.currentPage().getParameters().get('code'))));
         ps.setredirect(true);
         return ps; 
    //    return  null;
    }
    
}