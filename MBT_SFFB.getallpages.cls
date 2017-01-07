public with sharing class getallpages
{
       //This variable hold the id of  psge which is selected by enduser from picklist
        public String selectedpageId {set;get;}
      
      //This var hold List of pages
     public List<SelectOption> getListOfpages()
    {
               List<MBT_SFFB__Facebook_Page__c> facebookpages = [select ID,MBT_SFFB__Facebook_ID__c,MBT_SFFB__Facebook_Page_ID__c,MBT_SFFB__Facebook_Page_Name__c from MBT_SFFB__Facebook_Page__c] ;
               List<SelectOption> PagesList = new List<SelectOption>();
               PagesList.add(new SelectOption( ' ' ,'---Select---'));
               for(MBT_SFFB__Facebook_Page__c u : facebookpages )
               {
                          PagesList.add(new SelectOption(u.MBT_SFFB__Facebook_Page_ID__c , u.MBT_SFFB__Facebook_Page_Name__c));
               }
              return PagesList ;
    }
 
  public getallpages()
  {
                    selectedpageId ='';
  }
  public PageReference selectpage()
  {
      // redirect to the page with querystring.
        Pagereference ps=new Pagereference('/apex/Facebook_Posting?page='+selectedpageId);
         ps.setredirect(true);
         return ps;  
      
      
  }
 
}