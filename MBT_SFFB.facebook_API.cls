public class facebook_API
{
     public static string client_id {get;set;}
     public static string client_secret {get;set;}
     public static string sf_callbackpage ='https://mbt-sffb.ap2.visual.force.com/apex/getandsettokenvf';
     public static string fb_field{get;set;}
     public static string accesstoken{get;set;}
     public facebook_API()
     {
     
     }
    public static String deserializeLinkedINfield(string jsonstring,string fieldname) 
    {
        JSONParser parser = JSON.createParser(jsonstring);
        while (parser.nextToken() != null) 
        {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == fieldname)) 
            {              
                parser.nextToken();
                fb_field=parser.getText();
             
            }
        }
        return fb_field;
    }
    public static String getcode()
    {
     
           
            Http http =new Http();
            HttpRequest req =new HttpRequest();
            req.setEndpoint('https://www.facebook.com/dialog/oauth?client_id=847444638724852&redirect_uri=https://mbt-sffb.ap2.visual.force.com/apex/getandsettokenvf&scope=public_profile,publish_pages,manage_pages,user_friends,email,business_management&response_type=code');
            req.setmethod('GET');
            HttpResponse res = http.send(req);
            if(res.getStatusCode()==200)
             {
                 return res.getBody();
             }             
            else
            {
            System.Debug(res.getBody());
                return String.valueOf(res.getBody());
            }
            
            
    }
    public static String getownprofile(String token)
    {
            Boolean flag =false;
            Http http =new Http();
            HttpRequest req =new HttpRequest();
            req.setEndpoint('https://graph.facebook.com/me?fields=id,name,picture&access_token='+token);
            req.setmethod('GET');
            HttpResponse res = http.send(req);             
           facebookuser objfacebookuser = new facebookuser();
           objfacebookuser=facebookuser.parse(res.getBody());
           //System.Debug(res.getBody());
            MBT_SFFB__Facebook_User__c objMBT_SFFB_Facebook_User = new MBT_SFFB__Facebook_User__c(MBT_SFFB__Facebook_ID__c = objfacebookuser.id,MBT_SFFB__Facebook_Name__c =objfacebookuser.name,MBT_SFFB__Image__c = objfacebookuser.picture.data.url,MBT_SFFB__Validated__c=true);                 
              objMBT_SFFB_Facebook_User.MBT_SFFB__Facebook_ID__c = objfacebookuser.id;
                objMBT_SFFB_Facebook_User.MBT_SFFB__Facebook_Name__c =objfacebookuser.name;
                objMBT_SFFB_Facebook_User.MBT_SFFB__Image__c = objfacebookuser.picture.data.url;
                string abc=getfacebookpages(token,objMBT_SFFB_Facebook_User,objfacebookuser);
            return res.getBody();
            
    }
    public static String getfacebookpages(String token,MBT_SFFB__Facebook_User__c objMBT_SFFB_Facebook_User,facebookuser objfacebookuser)
    {
            string id='';
            Boolean flag =false;
            Http http =new Http();
            HttpRequest req =new HttpRequest();
            req.setEndpoint('https://graph.facebook.com/me?fields=accounts{id,name,picture,access_token}&access_token='+token);
            req.setmethod('GET');
            HttpResponse res = http.send(req);             
            MBT_SFFB.facebookpages objfacebookpages = new MBT_SFFB.facebookpages();
            objfacebookpages=MBT_SFFB.facebookpages.parse(res.getBody());
            id=objfacebookpages.id;
            list<MBT_SFFB.facebookpages.Data_Z> objallpageslst = new list<MBT_SFFB.facebookpages.Data_Z>();
            objallpageslst = objfacebookpages.accounts.data;           
            list<MBT_SFFB.facebookpost> obj_lst_facebookpost = new list<MBT_SFFB.facebookpost>();            
            for(MBT_SFFB.facebookpages.Data_Z objdatatz :objallpageslst)
            {
                Http http1 =new Http();
                HttpRequest req1 =new HttpRequest();
                req1.setEndpoint('https://graph.facebook.com/'+objdatatz.id+'?fields=id,name,feed{id,permalink_url,message,type,created_time,from,picture,comments{id,message,comment_count,created_time,attachment,from,like_count},likes{id,name,pic,profile_type,link,username}}&access_token='+objdatatz.access_token);
                req1.setmethod('GET');
                HttpResponse res1 = http1.send(req1);
                MBT_SFFB.facebookpost objfacebookpost = new MBT_SFFB.facebookpost();
                objfacebookpost=MBT_SFFB.facebookpost.parse(res1.getBody());
                 //String abc=getfacebookpagespost(objfacebookpost);
                obj_lst_facebookpost.add(objfacebookpost);
            }
            /*Map<String,String> objmapofimagepost = new Map<String,String>();
            Map<String,String> objmapofimagecomment = new Map<String,String>();
            for(MBT_SFFB.facebookpost obj_pagewisepost :obj_lst_facebookpost)
            {
                if(obj_pagewisepost.feed!=null)
                {
                    for(MBT_SFFB.facebookpost.Data_Y objmessage :obj_pagewisepost.feed.data)
                    {
                        Http http1 =new Http();
                        HttpRequest req1 =new HttpRequest();
                        req1.setEndpoint('https://graph.facebook.com/'+objmessage.from_Y.id+'?fields=id,name,picture&access_token='+token);
                        req1.setmethod('GET');
                        HttpResponse res1 = http.send(req1);             
                        facebookuser objfacebookuser1 = new facebookuser();
                        objfacebookuser1=facebookuser.parse(res1.getBody());
                        objmapofimagepost.put(objfacebookuser1.id,objfacebookuser1.picture.data.url);
                        if(objmessage.comments!=null)
                        {
                            for(MBT_SFFB.facebookpost.Data_Z objcomment :objmessage.comments.data)
                            {
                                
                                //System.Debug(objcomment);
                                Http http2 =new Http();
                                HttpRequest req2 =new HttpRequest();
                                req2.setEndpoint('https://graph.facebook.com/'+objcomment.from_Z.id+'?fields=id,name,picture&access_token='+token);
                                req2.setmethod('GET');
                                HttpResponse res2 = http.send(req2);             
                                facebookuser objfacebookuser2 = new facebookuser();
                                objfacebookuser2=facebookuser.parse(res2.getBody());
                                objmapofimagecomment.put(objfacebookuser2.id,objfacebookuser2.picture.data.url);
                                //System.Debug(objmapofimagecomment);
                            }
                        }
                    }
                }
            }*/
            list<MBT_SFFB__Application_Config__c> objappconfig_list = new list<MBT_SFFB__Application_Config__c>([select MBT_SFFB__App_Admin_User__c,MBT_SFFB__AppID__c,MBT_SFFB__Installed_Date__c,MBT_SFFB__Validated__c from MBT_SFFB__Application_Config__c where MBT_SFFB__Validated__c =:true]);
             String myname = UserInfo.getUserName();
            MBT_SFFB__Application_Config__c objappcofig = new MBT_SFFB__Application_Config__c();
            if(objappconfig_list.size()==0)
            {
                // create new app config and insert 
               
                Datetime myDT =DateTime.Now();
                objappcofig.MBT_SFFB__App_Admin_User__c=myname;
                objappcofig.MBT_SFFB__AppID__c='abc';
                objappcofig.MBT_SFFB__Installed_Date__c=myDT;
                objappcofig.MBT_SFFB__Validated__c=true;
                insert objappcofig;
                //MBT_SFFB__App_Admin_User__c=myname,MBT_SFFB__AppID__c='abc',MBT_SFFB__Installed_Date__c=myDT,MBT_SFFB__Validated__c=true
            }
            else
            {
                // assign MBT_SFFB__Application_Config__c 's ID 
                for(MBT_SFFB__Application_Config__c objconfig :objappconfig_list)
                {
                    objappcofig= objconfig;
                    break;
                }
                
            }
            User objuser = new user();
            objuser =  [Select Id,Name,Username from User where Username=:myname limit 1];
            list<MBT_SFFB__Application_User__c> objappuser_listtoinsert = new list<MBT_SFFB__Application_User__c>([select MBT_SFFB__Application_Config_For_User__c,MBT_SFFB__ApplicationUserName__c,MBT_SFFB__Validated__c from MBT_SFFB__Application_User__c where MBT_SFFB__ApplicationUserName__c =:objuser.Id limit 1]);
            
            
            MBT_SFFB__Application_User__c objuserapptoinsert = new MBT_SFFB__Application_User__c();
            if(objappuser_listtoinsert.size()==0)
            {
                // insert 
                objuserapptoinsert.MBT_SFFB__ApplicationUserName__c=objuser.Id;
                objuserapptoinsert.MBT_SFFB__Application_Config_For_User__c=objappcofig.Id;
                objuserapptoinsert.MBT_SFFB__Validated__c=true;
                insert objuserapptoinsert;
            }
            else
            {
                for(MBT_SFFB__Application_User__c objappuser : objappuser_listtoinsert)
                {
                    objuserapptoinsert=objappuser;
                    break;
                }
            }
            
            
            MBT_SFFB__Facebook_User__c objdbfbuser = new MBT_SFFB__Facebook_User__c();
            list<MBT_SFFB__Facebook_User__c> objlstMBT_SFFB_Facebook_User =new list<MBT_SFFB__Facebook_User__c>([Select MBT_SFFB__Facebook_ID__c,MBT_SFFB__Facebook_Name__c,MBT_SFFB__Image__c from MBT_SFFB__Facebook_User__c where MBT_SFFB__Validated__c!=false and MBT_SFFB__Facebook_ID__c=: objfacebookuser.id limit 1]);              
             if(objlstMBT_SFFB_Facebook_User.size()>0)
           {
                for(MBT_SFFB__Facebook_User__c objfbuser : objlstMBT_SFFB_Facebook_User )         
                {
                    if(objfbuser.MBT_SFFB__Facebook_ID__c==objfacebookuser.id)
                    {
                        flag=true;
                        objdbfbuser=objfbuser;
                        System.Debug(objdbfbuser);
                        objdbfbuser.Id=objfbuser.Id;
                        break;
                    }
                }
            
            }
            else
            {
                flag=false;
            }          
             
          if(flag!=true)
            {
                // insert into object
                objdbfbuser.MBT_SFFB__Facebook_ID__c = objfacebookuser.id;
                objdbfbuser.MBT_SFFB__Facebook_Name__c  =objfacebookuser.name;
                objdbfbuser.MBT_SFFB__Image__c = objfacebookuser.picture.data.url;
                objdbfbuser.MBT_SFFB__Validated__c =true;
                objdbfbuser.MBT_SFFB__Facebook_User_Relates_To_Application__c =objuserapptoinsert.Id;
                insert objdbfbuser; 

            }
            Map<String, MBT_SFFB__Facebook_Page__c> objmapfacebookallpages = new Map<String, MBT_SFFB__Facebook_Page__c>();
            for(MBT_SFFB__Facebook_Page__c obj : [Select  ID, MBT_SFFB__Facebook_ID__c, MBT_SFFB__Facebook_Page_ID__c, MBT_SFFB__Facebook_Page_Name__c,MBT_SFFB__Facebook_Page_Url__c,MBT_SFFB__Facebook_User_Relates_To_Page__c, MBT_SFFB__Image__c from MBT_SFFB__Facebook_Page__c]) 
            {
                objmapfacebookallpages.put(obj.MBT_SFFB__Facebook_Page_ID__c,obj);
            }            
            if(objmapfacebookallpages.size()>0)
            {
                 List<MBT_SFFB__Facebook_Page__c> objpagetobecreate = new List<MBT_SFFB__Facebook_Page__c>(); 
                 for(MBT_SFFB.facebookpages.Data_Z objpage :objallpageslst)
                 {
                     if((objmapfacebookallpages.containsKey(objpage.id))==false)
                     {
                         
                         MBT_SFFB__Facebook_Page__c objrecfbpage = new MBT_SFFB__Facebook_Page__c(MBT_SFFB__Facebook_ID__c=id,MBT_SFFB__Facebook_Page_ID__c=objpage.id,MBT_SFFB__Facebook_Page_Name__c=objpage.name,MBT_SFFB__Image__c=objpage.picture.data.url,MBT_SFFB__Facebook_Page_Url__c='https://www.facebook.com/'+objpage.id,MBT_SFFB__Facebook_User_Relates_To_Page__c=objdbfbuser.Id);                           
                         objpagetobecreate.Add(objrecfbpage);                     
                     }                                            
                 }
                 if(objpagetobecreate.size()>0)
                 {
                     insert objpagetobecreate;                   
                 }
            }
            else
            {
                // no page found in database insert all facebook pages
               list<MBT_SFFB__Facebook_Page__c> objmtfbpage = new list<MBT_SFFB__Facebook_Page__c>();
               for(facebookpages.Data_Z objfbpage :objallpageslst)
               {
                   MBT_SFFB__Facebook_Page__c objrecfbpage = new MBT_SFFB__Facebook_Page__c();
                   objrecfbpage.MBT_SFFB__Facebook_ID__c=id;
                   objrecfbpage.MBT_SFFB__Facebook_Page_ID__c=objfbpage.id;
                   objrecfbpage.MBT_SFFB__Facebook_Page_Name__c=objfbpage.name;
                   objrecfbpage.MBT_SFFB__Image__c=objfbpage.picture.data.url;           
                   objrecfbpage.MBT_SFFB__Facebook_User_Relates_To_Page__c=objdbfbuser.Id;
                   
                    objrecfbpage.MBT_SFFB__Facebook_Page_Url__c='https://www.facebook.com/'+objfbpage.id;
                    
                   objmtfbpage.add(objrecfbpage);
               }
               insert objmtfbpage;                
            } 
           // String abc=getfacebookpagespost(obj_lst_facebookpost,objmapofimagepost,objmapofimagecomment);             
           String abc=getfacebookpagespost(obj_lst_facebookpost);
            return res.getBody();            
    }
    //public static String getfacebookpagespost(list<MBT_SFFB.facebookpost> obj_lst_facebookpost,Map<String,String> objmapofimagepost,Map<String,String> objmapofimagecomment)
    public static String getfacebookpagespost(list<MBT_SFFB.facebookpost> obj_lst_facebookpost)
    {
        String pageid='';
        String pagename='';
        Integer new_like_count=0;
        List<Contact> objlistcontact = new List<Contact>([Select MBT_SFFB__Facebook_Id__c,MBT_SFFB__Username__c from contact where MBT_SFFB__Facebook_Id__c!=:null]);
        Map<string,string> contactextid = new Map<string,string>();
        for(Contact c: objlistcontact)
        {
            contactextid.put(c.MBT_SFFB__Facebook_Id__c,c.Id);
        }        
        List<MBT_SFFB__Conversation__c> objconversationlst = new List<MBT_SFFB__Conversation__c>();
        List<MBT_SFFB__Conversation__c> objcommentinsertlst = new List<MBT_SFFB__Conversation__c>();
        list<MBT_SFFB__Facebook_Page__c> objmtfbpage = new list<MBT_SFFB__Facebook_Page__c>();
        objmtfbpage=[Select  ID, MBT_SFFB__Facebook_ID__c, MBT_SFFB__Facebook_Page_ID__c, MBT_SFFB__Facebook_Page_Name__c, MBT_SFFB__Facebook_User_Relates_To_Page__c, MBT_SFFB__Image__c from MBT_SFFB__Facebook_Page__c];
        for(MBT_SFFB.facebookpost obj_pagewisepost :obj_lst_facebookpost)
        {
           if(obj_pagewisepost.feed!=null)
           {               
               pageid=obj_pagewisepost.id;
               pagename=obj_pagewisepost.name;
               String recordid='';
               for(MBT_SFFB__Facebook_Page__c objpage :objmtfbpage)
               {
                    if(objpage.MBT_SFFB__Facebook_Page_ID__c==pageid)
                    {
                        recordid=String.valueOf(objpage.Id).substring(0,15);
                    }            
               }              
               list<MBT_SFFB.facebookpost.Data_Y> objpost = new list<MBT_SFFB.facebookpost.Data_Y>();   
               list<MBT_SFFB.facebookpost.Data_Z> objcomments = new list<MBT_SFFB.facebookpost.Data_Z>();               
               list<MBT_SFFB.facebookpost.Data> objlikes = new list<MBT_SFFB.facebookpost.Data>();            
               objpost=obj_pagewisepost.feed.data;               
               
               for(MBT_SFFB.facebookpost.Data_Y objmessage :objpost)
               {
                   if(objmessage.type_Z=='status')
                   {
                         Integer totalcomments=0;
                       if(objmessage.comments!=null)
                       {    
                           totalcomments = (objmessage.comments.data).size();
                       }                   
                    //  Datetime myDT = DateTime.newInstance(objmessage.created_time);
                    //  Datetime myDT1 =myDT.format('YYYY-MM-DD');              
                    //  DateTime dt1 = DateTime.parse(objmessage.created_time);
                    //  Datetime myDT1 =dt1.format('YYYY-MM-DD');
                    String Imageurlpost='';
                    /*if((objmapofimagepost.get(objmessage.from_Y.id))!=null)
                    {
                        Imageurlpost=objmapofimagepost.get(objmessage.from_Y.id);
                    }*/
                    
                    MBT_SFFB__Conversation__c obj_conversation =  new MBT_SFFB__Conversation__c();
                    if(contactextid.size()>0)
                    {
                        if(contactextid.containsKey(objmessage.from_Y.id))
                        {
                            obj_conversation.MBT_SFFB__Conversation_Contact__c=contactextid.get(objmessage.from_Y.id);
                        }
                    }
                    obj_conversation.MBT_SFFB__Author_External_Id__c = objmessage.from_Y.id;
                    obj_conversation.MBT_SFFB__Author_URL__c = 'http://www.facebook.com/'+objmessage.from_Y.id;
                    obj_conversation.MBT_SFFB__Author_Realname__c = objmessage.from_Y.name;
                    obj_conversation.MBT_SFFB__Is_Status__c=true;
                    //obj_conversation.MBT_SFFB__Collected_Comments__c = objmessage.
                    obj_conversation.MBT_SFFB__External_ID__c = objmessage.id;
                    obj_conversation.MBT_SFFB__Facebook_Page__c = recordid;
                    obj_conversation.MBT_SFFB__Is_Comment__c = false;
                    //obj_conversation.MBT_SFFB__Likes_Count__c = 
                    obj_conversation.MBT_SFFB__Link__c = objmessage.permalink_url;
                    obj_conversation.MBT_SFFB__Message__c = objmessage.message;
                    obj_conversation.MBT_SFFB__parent__c= null;
                   // obj_conversation.MBT_SFFB__Image__c=Imageurlpost;
                    //obj_conversation.MBT_SFFB__Post_And_Comment_Retrieved_From__c = myDT1;
                    //obj_conversation.MBT_SFFB__Post_And_Comment_Retrieved_Untill__c = dt1;
                    //obj_conversation.MBT_SFFB__Profile_Type__c = objmessage.
                    //obj_conversation.MBT_SFFB__Published_Date__c = dt1;
                    //obj_conversation.MBT_SFFB__Replied_Conversation_s_External_Id__c = null;
                    //obj_conversation.MBT_SFFB__Replied_User_s_External_Id__c = objmessage.
                    obj_conversation.MBT_SFFB__Collected_Comments__c =totalcomments;
                    obj_conversation.MBT_SFFB__Total_Comments__c= totalcomments;
                    objconversationlst.add(obj_conversation);
                   } 
                   else if(objmessage.type_Z=='photo')
                   {
                       Integer totalcomments=0;
                   if(objmessage.comments!=null)
                   {    
                       totalcomments = (objmessage.comments.data).size();
                   }                   
                    //  Datetime myDT = DateTime.newInstance(objmessage.created_time);
                    //  Datetime myDT1 =myDT.format('YYYY-MM-DD');              
                    //  DateTime dt1 = DateTime.parse(objmessage.created_time);
                    //  Datetime myDT1 =dt1.format('YYYY-MM-DD');
                    String Imageurlpost='';
                    
                    
                    MBT_SFFB__Conversation__c obj_conversation =  new MBT_SFFB__Conversation__c();
                    if(contactextid.size()>0)
                    {
                        if(contactextid.containsKey(objmessage.from_Y.id))
                        {
                            obj_conversation.MBT_SFFB__Conversation_Contact__c=contactextid.get(objmessage.from_Y.id);
                        }
                    }
                    obj_conversation.MBT_SFFB__Author_External_Id__c = objmessage.from_Y.id;
                    obj_conversation.MBT_SFFB__Author_URL__c = 'http://www.facebook.com/'+objmessage.from_Y.id;
                    obj_conversation.MBT_SFFB__Author_Realname__c = objmessage.from_Y.name;
                    obj_conversation.MBT_SFFB__External_ID__c = objmessage.id;
                    obj_conversation.MBT_SFFB__Is_Status__c=false;      
                    obj_conversation.MBT_SFFB__Facebook_Page__c = recordid;
                    obj_conversation.MBT_SFFB__Is_Comment__c = false;
                    obj_conversation.MBT_SFFB__Photo_Url__c=objmessage.picture;
                    //obj_conversation.MBT_SFFB__Likes_Count__c = 
                    obj_conversation.MBT_SFFB__Link__c = objmessage.permalink_url;
                    obj_conversation.MBT_SFFB__parent__c= null;
                    obj_conversation.MBT_SFFB__Collected_Comments__c =totalcomments;
                    obj_conversation.MBT_SFFB__Total_Comments__c= totalcomments;
                    objconversationlst.add(obj_conversation);
                   }               
                                                                                      
               }               
               if(objconversationlst.size()>0)
               {
                   insert objconversationlst;
               }               
               List<MBT_SFFB__Conversation__c> objconversationlistforparent = new List<MBT_SFFB__Conversation__c>();
               objconversationlistforparent = [select Id,Name,MBT_SFFB__Author_External_Id__c,MBT_SFFB__Author_Realname__c,MBT_SFFB__Author_URL__c,MBT_SFFB__Collected_Comments__c,MBT_SFFB__Contact_Created__c,MBT_SFFB__Conversation_Contact__c,MBT_SFFB__External_ID__c,MBT_SFFB__Facebook_Page__c,MBT_SFFB__Is_Comment__c,MBT_SFFB__Likes_Count__c,MBT_SFFB__Link__c,MBT_SFFB__Message__c,MBT_SFFB__Paging__c,MBT_SFFB__Parent__c,MBT_SFFB__Post_And_Comment_Retrieved_From__c,MBT_SFFB__Post_And_Comment_Retrieved_Untill__c,MBT_SFFB__Profile_Type__c,MBT_SFFB__Published_Date__c,MBT_SFFB__Replied_Conversation_s_External_Id__c,MBT_SFFB__Replied_User_s_External_Id__c,MBT_SFFB__Total_Comments__c,MBT_SFFB__Uncollected_Comments__c FROM MBT_SFFB__Conversation__c];
               
               for(MBT_SFFB.facebookpost.Data_Y objmessages :objpost)
               {
                   integer underscoreposition  =(objmessages.id).indexOfAny('_');
                   String Id = '';
                   String postids= (objmessages.id).substring((underscoreposition+1),(objmessages.id).length());
                   for(MBT_SFFB__Conversation__c objconvers : objconversationlistforparent)
                   {
                       if(objconvers.MBT_SFFB__External_ID__c==objmessages.id)
                       {
                           Id=String.valueOf((objconvers.Id)).substring(0,15);
                           break;
                       }
                   }                  
                   if(objmessages.comments!=null)
                   {                   
                       objcomments = objmessages.comments.data;                        
                       for(MBT_SFFB.facebookpost.Data_Z objcomment :objcomments)
                       {
                           String Imageurlcomments='';
                           /* if((objmapofimagepost.get(objcomment.from_Z.id))!=null)
                            {
                                Imageurlcomments=objmapofimagepost.get(objcomment.from_Z.id);
                            }
                            else
                            {
                               // System.Debug(objcomment.from_Z.id);
                            }*/
                           integer underscorepositionofcomment = (objcomment.id).indexOfAny('_');
                           String postidsd= (objcomment.id).substring(0,(underscorepositionofcomment));
                           MBT_SFFB__Conversation__c obj_conversation1 =  new MBT_SFFB__Conversation__c();
                           if(contactextid.size()>0)
                    {
                        if(contactextid.containsKey(objcomment.from_Z.id))
                        {
                            obj_conversation1.MBT_SFFB__Conversation_Contact__c=contactextid.get(objcomment.from_Z.id);
                        }
                    }
                           obj_conversation1.MBT_SFFB__Author_External_Id__c =  objcomment.from_Z.id;
                           obj_conversation1.MBT_SFFB__Author_URL__c = 'http://www.facebook.com/'+objcomment.from_Z.id;
                           obj_conversation1.MBT_SFFB__Author_Realname__c = objcomment.from_Z.name;                           
                           obj_conversation1.MBT_SFFB__External_ID__c = objcomment.id;
                           obj_conversation1.MBT_SFFB__Facebook_Page__c = recordid;
                           obj_conversation1.MBT_SFFB__Is_Comment__c = true;
                          // obj_conversation1.MBT_SFFB__Image__c=Imageurlcomments;
                           //  obj_conversation1.MBT_SFFB__Likes_Count__c = 
                           obj_conversation1.MBT_SFFB__Link__c = objmessages.permalink_url;
                           obj_conversation1.MBT_SFFB__Message__c = objcomment.message;
                           obj_conversation1.MBT_SFFB__parent__c = Id;
                           //    obj_conversation1.MBT_SFFB__Post_And_Comment_Retrieved_From__c = myDT1;
                           //  obj_conversation1.MBT_SFFB__Post_And_Comment_Retrieved_Untill__c = dt1;
                           // obj_conversation1.MBT_SFFB__Profile_Type__c = objcomment.
                           //  obj_conversation1.MBT_SFFB__Published_Date__c = dt1;
                           obj_conversation1.MBT_SFFB__Replied_Conversation_s_External_Id__c = objmessages.id;
                           obj_conversation1.MBT_SFFB__Replied_User_s_External_Id__c = objcomment.from_Z.id;
                           obj_conversation1.MBT_SFFB__Collected_Comments__c= objcomment.comment_count;
                           obj_conversation1.MBT_SFFB__Total_Comments__c= objcomment.comment_count;
                           objcommentinsertlst.add(obj_conversation1);                               
                        }
                       // System.Debug(objcommentinsertlst);
                   }
               }
               if(objcommentinsertlst.size()>0)
               {
                   insert objcommentinsertlst;
               }
            }
       }
       return '';
   }   
    public static String gotAccessTocken(String code)
     { 
                
             // valid request from the facebook                   
             PageReference p = new PageReference('https://graph.facebook.com/v2.8/oauth/access_token?');
             p.getParameters().put('client_id','847444638724852');
             p.getParameters().put('code',code);
             p.getParameters().put('redirect_uri',sf_callbackpage);
             p.getParameters().put('client_secret','ca77d8f69d4d814967a1db93c8d2b6bf');
             String body = p.getURL();
             body = body.subStringAfter('?');
             HttpRequest req = new HttpRequest();
             req.setEndpoint('https://graph.facebook.com/v2.8/oauth/access_token');
             req.setMethod('POST');
             req.setCompressed(false);             
             req.setTimeout(120000);//max timeout
             if(body != null)
             { 
                 req.setBody(body);
                 req.setHeader('Content-length',string.valueOf(body.length()));
             }
             HttpResponse res = new http().send(req);
             return accesstoken= deserializeLinkedINfield(res.getBody(),'access_token'); // retrieves access token and returns it
             //return res.getBody();
             /*if(res.getStatusCode()==200)
             {
            // return res.getBody();
                           
             }
             else
             {
                 return String.valueOf(res.getStatusCode());
             }*/
         
     }
}