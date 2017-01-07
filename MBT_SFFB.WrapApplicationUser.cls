public class WrapApplicationUser
    {
        public MBT_SFFB__Application_User__c  appuser{get; set;}
         public User u{get; set;}
        public Boolean validated {get; set;}
        public ID applicationusername {get; set;} 
        public ID applicationconfigforuser {get; set;}
        public String userusername{get; set;}
        public String emailuser{get; set;} 
        public WrapApplicationUser(MBT_SFFB__Application_User__c a)
        {
           //  appuser = new MBT_SFFB__Application_User__c(MBT_SFFB__ApplicationUserName__c=a.MBT_SFFB__ApplicationUserName__c,MBT_SFFB__Application_Config_For_User__c=a.MBT_SFFB__Application_Config_For_User__c,MBT_SFFB__Validated__c=a.MBT_SFFB__Validated__c);
           appuser =a;
            /*appuser.MBT_SFFB__ApplicationUserName__r.Username=a.MBT_SFFB__ApplicationUserName__r.Username;
            appuser.MBT_SFFB__ApplicationUserName__r.Email=a.MBT_SFFB__ApplicationUserName__r.Email;
            WrapApplicationUser objwaprappuser =new WrapApplicationUser();
            objwaprappuser.applicationusername=appuser.MBT_SFFB__ApplicationUserName__c;
             objwaprappuser.applicationconfigforuser=appuser.MBT_SFFB__Application_Config_For_User__c;
              objwaprappuser.userusername=appuser.MBT_SFFB__ApplicationUserName__r.Username;
               objwaprappuser.emailuser=appuser.MBT_SFFB__ApplicationUserName__r.Email;
               objwaprappuser.validated=appuser.MBT_SFFB__Validated__c;*/
            /*appuser.applicationusername=a.MBT_SFFB__ApplicationUserName__c;
            appuser.applicationconfigforuser=a.MBT_SFFB__Application_Config_For_User__c;*/
            /*validated=a.MBT_SFFB__Validated__c;
            applicationusername=a.MBT_SFFB__ApplicationUserName__c;
            applicationconfigforuser=a.MBT_SFFB__Application_Config_For_User__c;*/
            //userusername=a.MBT_SFFB__ApplicationUserName__r.Username;
           // emailuser=a.MBT_SFFB__ApplicationUserName__r.Email;
        }
        public WrapApplicationUser(User a)
        {
            u=a;
            validated=false;
            /*WrapApplicationUser objwaprappuser =new WrapApplicationUser();
           // objwaprappuser.applicationusername=a.MBT_SFFB__ApplicationUserName__c;
           //  objwaprappuser.applicationconfigforuser=a.MBT_SFFB__Application_Config_For_User__c;
              objwaprappuser.userusername=u.Username;
               objwaprappuser.emailuser=u.Email;
               objwaprappuser.validated=false;*/
        }
        public WrapApplicationUser()
        {
        }
    }