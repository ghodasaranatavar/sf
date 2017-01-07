public class getandsettoken
{
    public getandsettoken()
    {
        
    }
    public PageReference gettoken()
    {
        
         Pagereference ps=new Pagereference('/apex/socialsetup?access_token='+MBT_SFFB.facebook_API.gotAccessTocken((ApexPages.currentPage().getParameters().get('code'))));
       //  System.Debug(MBT_SFFB.facebook_API.gotAccessTocken((ApexPages.currentPage().getParameters().get('code'))));
         ps.setredirect(true);
         return ps; 
        //return  null;
        
    }
}