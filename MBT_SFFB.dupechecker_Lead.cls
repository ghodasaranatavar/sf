/**
@author Innodel Technologies PVT LTD
@date 21 th OCT 2016
@description Checkes duplicate and insert Lead if record not Exist.
*/

global class dupechecker_Lead
{
    public String leadName { get; set; }
    public String leadCompany{ get; set; }
    public String leadPhone { get; set; }
    public Lead objleadref {get;set;}
    public static Lead newlead { get; set; }
    public static List<Lead> lead { get; set; }
    public static ID LeadID { get; set; }
    public static String LeadnewName { get; set; }
    public static Integer noofLead { get; set; }
    public static boolean emptyLeadList { get; set; }
    public static boolean noLeadResult { get; set; }
    public dupechecker_Lead(ApexPages.StandardController con) {           
         objleadref = new Lead();
           
    }
    /**
@date 21 th OCT 2016
@description Inserts Lead with params and returns ID in string format - JSremote method
@param leadName Name of lead to insert
@param leadPhone Phone no of lead to insert
@param leadCompany Company of lead to insert
*/
     @RemoteAction
    global static String insertLead(String leadName,String leadPhone,String leadCompany) 
    {
        try
        {
            newlead= new Lead();
            newlead.LastName =leadName;
            newlead.Phone =leadPhone;
            newlead.Company=leadCompany;
            newlead.Status ='Open - Not Contacted';
            insert newlead;
            return String.valueOf(newlead.id);

        }
    catch (Exception ex)
    {
       return 'Exception';
    }
        
        
    }
      /**
@date 21 th OCT 2016
@description Returns List<Lead> that have parameters name,phone no,company. - JSremote method
@param leadName Name of lead entered for searching
@param leadPhone Phone no of lead entered for searching
@param leadCompany Company of lead entered for searching
*/
    @RemoteAction
    global static List<Lead> getLead(String leadName,String leadPhone,String leadCompany) 
    {
        nooflead =0;
        
         if((!(String.isBlank(leadName)))&&(!(String.isBlank(leadPhone)))&&(!(String.isBlank(leadCompany))))
         {
         leadName=leadName+'%';
        leadPhone=leadPhone+'%';
        leadCompany=leadCompany+'%';
            lead=[select ID,Name,Phone,Email,Company,Status from Lead where FirstName LIKE: leadName OR Phone LIKE: leadPhone OR Company LIKE: leadCompany];
         }
         else if(((String.isBlank(leadName)))&&(!(String.isBlank(leadPhone)))&&(!(String.isBlank(leadCompany))))
         {

        leadPhone=leadPhone+'%';
        leadCompany=leadCompany+'%';
        lead=[select ID,Name,Phone,Email,Company,Status from Lead where Phone LIKE: leadPhone OR Company LIKE: leadCompany];

         }
         else if((!(String.isBlank(leadName)))&&((String.isBlank(leadPhone)))&&(!(String.isBlank(leadCompany))))
         {
         leadName=leadName+'%';
        leadCompany=leadCompany+'%';
        lead=[select ID,Name,Phone,Email,Company,Status from Lead where FirstName LIKE: leadName OR Company LIKE: leadCompany];
            
         }
         else if((!(String.isBlank(leadName)))&&(!(String.isBlank(leadPhone)))&&((String.isBlank(leadCompany))))
         {
         leadName=leadName+'%';
        leadPhone=leadPhone+'%';
        lead=[select ID,Name,Phone,Email,Company,Status from Lead where FirstName LIKE: leadName OR Phone LIKE: leadPhone];
            
         }
         else if((!(String.isBlank(leadName)))&&((String.isBlank(leadPhone)))&&((String.isBlank(leadCompany))))
         {
         leadName=leadName+'%';
            lead=[select ID,Name,Phone,Email,Company,Status from Lead where FirstName LIKE: leadName];
            
         }
         else if(((String.isBlank(leadName)))&&(!(String.isBlank(leadPhone)))&&((String.isBlank(leadCompany))))
         {

        leadPhone=leadPhone+'%';
  
            lead=[select ID,Name,Phone,Email,Company,Status from Lead where Phone LIKE: leadPhone];
         }
         else if(((String.isBlank(leadName)))&&((String.isBlank(leadPhone)))&&(!(String.isBlank(leadCompany))))
         {

        leadCompany=leadCompany+'%';
            lead=[select ID,Name,Phone,Email,Company,Status from Lead where Company LIKE: leadCompany];
         }
         noofLead=lead.size();
         emptyLeadList= lead.isEmpty() ? true : false;
         noLeadResult=emptyLeadList;
        return lead;
    }
}