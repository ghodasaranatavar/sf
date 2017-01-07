global with sharing class socialsetup
{
    //public List <MBT_SFFB__Application_User__c> appuserlist {get;set;}
    public List <MBT_SFFB.WrapApplicationUser> appuserlist {get;set;}
    public List <MBT_SFFB.WrapApplicationUser> otheruserlist {get;set;}
    public List <User> avaiableuser {get;set;}
    public List <User> avaiableusers {get;set;}
    public string token {get;set;}
    public string profile {get;set;}
    public string pages {get;set;}
    public String selectedconfigId {set;get;}
    public List<MBT_SFFB__Application_Config__c> listappconfig {get;set;}
    public List<MBT_SFFB__Facebook_Page__c> listfbpages {get;set;}
    public List<SelectOption> configList {get;set;}
    public List <MBT_SFFB.WrapApplicationUser> selectedusers = new List<MBT_SFFB.WrapApplicationUser>();
    public socialsetup()
    {
          
    }
   /* public PageReference getcode()
    {
        profile= MBT_SFFB.facebook_API.getcode();
        System.Debug(profile);
        return null;
    }*/
   public List<SelectOption> getappuserlistmethod()
    {
        
         listappconfig = [select Id,Name,MBT_SFFB__App_Admin_User__c,MBT_SFFB__AppID__c,MBT_SFFB__Installed_Date__c,MBT_SFFB__Validated__c from MBT_SFFB__Application_Config__c where MBT_SFFB__Validated__c!=false];         
         configList = new List<SelectOption>();
        // configList.add(new SelectOption(' ' ,'---Select---'));
         for(MBT_SFFB__Application_Config__c  u : listappconfig)
         {                 
             configList.add(new SelectOption(u.Id, u.Name));
         }
        
         return configList;
    }
    
    public PageReference getprofile()
    {
         
    if(ApexPages.currentPage().getParameters().get('access_token')!=null)
        {
        //MBT_SFFB.facebook_API obj_MBT_SFFBfacebook_API = new MBT_SFFB.facebook_API();
        
           token=ApexPages.currentPage().getParameters().get('access_token');
           
         profile = MBT_SFFB.facebook_API.getownprofile(token);
          //  pages = MBT_SFFB.facebook_API.getfacebookpages(token);
            //string profile = obj_MBT_SFFBfacebook_API.getownprofile(token);
            
        }
        
        listfbpages = new List<MBT_SFFB__Facebook_Page__c>();
         selectedconfigId='';
        string myusername=UserInfo.getUserName();
        appuserlist = new List<MBT_SFFB.WrapApplicationUser>();        
        otheruserlist= new List<MBT_SFFB.WrapApplicationUser>();
       
        /*avaiableuser  = new List<User>(); */      
        for(MBT_SFFB__Application_User__c obj_wrapappuser :[SELECT MBT_SFFB__Application_Config_For_User__r.Name,MBT_SFFB__ApplicationUserName__c,MBT_SFFB__ApplicationUserName__r.Username,MBT_SFFB__ApplicationUserName__r.Email,MBT_SFFB__Application_Config_For_User__c,MBT_SFFB__Validated__c FROM MBT_SFFB__Application_User__c where MBT_SFFB__ApplicationUserName__r.UserName !=:myusername])   
         {
             appuserlist.add(new MBT_SFFB.WrapApplicationUser(obj_wrapappuser));
         }             
         for(User obj_wrapappuser :[SELECT Id,Name,Username,UserType,Email FROM User where UserType!='Guest' And Username!=:myusername And Id NOT IN(SELECT MBT_SFFB__ApplicationUserName__c FROM MBT_SFFB__Application_User__c)])   
         {
             otheruserlist.add(new MBT_SFFB.WrapApplicationUser(obj_wrapappuser));         
         }
         for(MBT_SFFB__Facebook_Page__c objpage :[select MBT_SFFB__Facebook_ID__c,MBT_SFFB__Image__c,MBT_SFFB__Facebook_User_Relates_To_Page__r.Name,MBT_SFFB__Facebook_Page_Url__c,MBT_SFFB__Facebook_Page_ID__c,MBT_SFFB__Facebook_Page_Name__c from MBT_SFFB__Facebook_Page__c])       
         {
             listfbpages.add(objpage);
         } 
        return null;
    }
     public List <MBT_SFFB.WrapApplicationUser> getApplicationUsers()
    {

       string myusername=UserInfo.getUserName();  
        for(MBT_SFFB__Application_User__c obj_wrapappuser :[SELECT MBT_SFFB__Application_Config_For_User__r.Name,MBT_SFFB__ApplicationUserName__c,MBT_SFFB__Application_Config_For_User__c,MBT_SFFB__Validated__c FROM MBT_SFFB__Application_User__c])   
         {
             appuserlist.add(new MBT_SFFB.WrapApplicationUser(obj_wrapappuser));
         }
        return appuserlist;
    }
    public PageReference getSelected()
    {
        string myusername=UserInfo.getUserName();
       list<MBT_SFFB.WrapApplicationUser> allowuserupdate = new list<MBT_SFFB.WrapApplicationUser>();
       list<MBT_SFFB__Application_User__c> objappuserlist = new list<MBT_SFFB__Application_User__c>();
       list<MBT_SFFB__Application_Config__c> objappconfig =new list<MBT_SFFB__Application_Config__c>();
       
       if((selectedconfigId!='')&&(selectedconfigId!=null))
      {
           for(MBT_SFFB.WrapApplicationUser objwarpp :otheruserlist)   
             {
                if(objwarpp.validated==true)
                {            
                   allowuserupdate.add(objwarpp); 
                }         
             }
             if(allowuserupdate.size()>0)
             {
                 // insert into 
                 for(MBT_SFFB.WrapApplicationUser objwrapus :allowuserupdate)
                 {
                    objappuserlist.add(new MBT_SFFB__Application_User__c(MBT_SFFB__Validated__c=objwrapus.validated,MBT_SFFB__ApplicationUserName__c=objwrapus.u.Id,MBT_SFFB__Application_Config_For_User__c=selectedconfigId));
                 }
                              
                 insert objappuserlist;
             
             }
             else
             {
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Users To Add.'));

           // return null;
             }
             appuserlist.clear();
             otheruserlist.clear();
             for(MBT_SFFB__Application_User__c obj_wrapappuser :[SELECT MBT_SFFB__Application_Config_For_User__r.Name,MBT_SFFB__ApplicationUserName__c,MBT_SFFB__ApplicationUserName__r.Username,MBT_SFFB__ApplicationUserName__r.Email,MBT_SFFB__Application_Config_For_User__c,MBT_SFFB__Validated__c FROM MBT_SFFB__Application_User__c where MBT_SFFB__ApplicationUserName__r.UserName !=:myusername])   
         {
             appuserlist.add(new MBT_SFFB.WrapApplicationUser(obj_wrapappuser));
         }             
         for(User obj_wrapappuser :[SELECT Id,Name,Username,UserType,Email FROM User where UserType!='Guest' And Username!=:myusername And Id NOT IN(SELECT MBT_SFFB__ApplicationUserName__c FROM MBT_SFFB__Application_User__c)])   
         {
             otheruserlist.add(new MBT_SFFB.WrapApplicationUser(obj_wrapappuser));         
         }
       }
       else
       {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Configuration.'));
          }
         return null;
       
    }
public PageReference removeSelected()
    {
        string myusername=UserInfo.getUserName();
       list<MBT_SFFB.WrapApplicationUser> allowuserupdate = new list<MBT_SFFB.WrapApplicationUser>();
       list<MBT_SFFB__Application_User__c> objappuserlist = new list<MBT_SFFB__Application_User__c>();
       for(MBT_SFFB.WrapApplicationUser objwarpp :appuserlist)   
         {
            if(objwarpp.appuser.MBT_SFFB__Validated__c==true)
            {            
               allowuserupdate.add(objwarpp);
               
            }         
         }
         if(allowuserupdate.size()>0)
         {
             // delete from 
             for(MBT_SFFB.WrapApplicationUser objwrapus :allowuserupdate)
             {
                objappuserlist.add(new MBT_SFFB__Application_User__c(Id=objwrapus.appuser.Id,MBT_SFFB__Validated__c=objwrapus.appuser.MBT_SFFB__Validated__c,MBT_SFFB__ApplicationUserName__c=objwrapus.appuser.MBT_SFFB__ApplicationUserName__c,MBT_SFFB__Application_Config_For_User__c=objwrapus.appuser.MBT_SFFB__Application_Config_For_User__c));
             }             
             delete objappuserlist;
             
         }
         else
         {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Users To Remove.'));

           // return null;
         }
         appuserlist.clear();
         otheruserlist.clear();
         for(MBT_SFFB__Application_User__c obj_wrapappuser :[SELECT MBT_SFFB__Application_Config_For_User__r.Name,MBT_SFFB__ApplicationUserName__c,MBT_SFFB__ApplicationUserName__r.Username,MBT_SFFB__ApplicationUserName__r.Email,MBT_SFFB__Application_Config_For_User__c,MBT_SFFB__Validated__c FROM MBT_SFFB__Application_User__c where MBT_SFFB__ApplicationUserName__r.UserName !=:myusername])   
         {
             appuserlist.add(new MBT_SFFB.WrapApplicationUser(obj_wrapappuser));
         }             
         for(User obj_wrapappuser :[SELECT Id,Name,Username,UserType,Email FROM User where UserType!='Guest' And Username!=:myusername And Id NOT IN(SELECT MBT_SFFB__ApplicationUserName__c FROM MBT_SFFB__Application_User__c)])   
         {
             otheruserlist.add(new MBT_SFFB.WrapApplicationUser(obj_wrapappuser));         
         }
         return null;
       
    }
    /*public List<MBT_SFFB__Application_User__c> Getselectedusers()
    {
        if(selectedusers.size()>0)
        return selectedusers;
        else
        return null;
    } */



    @RemoteAction
    public static string getuserinfo()
    {
      string currentuserisadmin;
      list<profile> lstprofile= [SELECT ID from profile where Name='System Administrator'];
      if(lstprofile.size()>0)
      {
          for(integer i=0;i<lstprofile.size();i++)
          {
              if(UserInfo.getProfileId()==lstprofile[i].ID)
              {
                  // match found
                 currentuserisadmin='yes';     
                 break;
              }
              else
              {
                   // match not found
                 currentuserisadmin='no';  

              }
          }
      }
       return currentuserisadmin; 
    }
    @RemoteAction
    public static list<User> getallusers()
    {
    string myusername=UserInfo.getUserName();
        return [SELECT Id,Name,Username,UserType,Email FROM User where Username!=:myusername and UserType!=:'Guest'];
         /* List<Profile> profileList =[Select Id, Name, (Select Id, Name From Users) From Profile];
          User userObj = new user();
        Map<Id, List<User>> UserMap = new Map<Id, List<User>>();
        Map<Id,string> profileIdNameMap = new map<Id,string>();
        List<User> UserList = new List<User>();
        for(Profile a : profileList)
        {
          UserList.add(a.getSObjects('Users')); 
          
        }*/
       
    }
    @RemoteAction
    public static list<MBT_SFFB__Application_User__c> getallactiveusers()
    {

        return [SELECT MBT_SFFB__ApplicationUserName__r.Username,MBT_SFFB__Application_Config_For_User__c,MBT_SFFB__Validated__c FROM MBT_SFFB__Application_User__c];         
       
    }
     @RemoteAction
    public static string updateusers(Boolean validate,string recid)
    {

        MBT_SFFB__Application_User__c obj_appuser = new MBT_SFFB__Application_User__c();
        Id newId = Id.valueOf(recid);
        obj_appuser =[SELECT MBT_SFFB__ApplicationUserName__r.Username,MBT_SFFB__Application_Config_For_User__c,MBT_SFFB__Validated__c FROM MBT_SFFB__Application_User__c where MBT_SFFB__ApplicationUserName__c=:newId];
        
        obj_appuser.MBT_SFFB__Validated__c =validate;
        update obj_appuser;
        return string.valueOf(obj_appuser.MBT_SFFB__Validated__c);
        //return 'yes';
       
    }    
      
    
}