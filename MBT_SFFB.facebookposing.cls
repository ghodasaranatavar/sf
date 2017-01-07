public with sharing class facebookposing
{
    public string pageid{get;set;}
    public string pagename{get;set;}
    public string pagepicture{get;set;}
    public List<MBT_SFFB__Conversation__c>  objpostlist {get;set;}
    public List<MBT_SFFB__Conversation__c>  objcommentlist {get;set;}
    public list<postandcommentswrapper> wraplist=new list<postandcommentswrapper>();
    public Map<String,MBT_SFFB__Conversation__c> objmappost {get;set;}
    public Map<String,list<MBT_SFFB__Conversation__c>> objmapcomment {get;set;}
    public string pageurl{get;set;}
    public Id postid{get;set;}
    public string pagepost{get;set;}
    public list<MBT_SFFB__Conversation__c> contactlistbypage{get;set;}
    public facebookposing()
    {
    
    contactbind();
        if(ApexPages.currentPage().getParameters().get('page')!=null)
         {        
                
              pageid =ApexPages.currentPage().getParameters().get('page');
              objpostlist = new List<MBT_SFFB__Conversation__c>();
              objmappost = new Map<String,MBT_SFFB__Conversation__c>();
             objmapcomment= new  Map<String,list<MBT_SFFB__Conversation__c>>();
             // objmappostandcomment.clear();
              objcommentlist =new List<MBT_SFFB__Conversation__c>();               
             /* Map<Id, postandcommentswrapper> accMap=new Map<Id, postandcommentswrapper>();
              for(MBT_SFFB__Conversation__c a:[SELECT MBT_SFFB__Message__c,MBT_SFFB__Author_URL__c,MBT_SFFB__Author_Realname__c(SELECT MBT_SFFB__Message__c,MBT_SFFB__Author_URL__c,MBT_SFFB__Author_Realname__c FROM MBT_SFFB__Conversation__c.Conversations ) FROM MBT_SFFB__Conversation__c ])
              {           
                AccountWrapper accWrap=accMap.get(a.CreatedByID);
               if (null==accWrap)
               {              
                  accWrap=new AccountWrapper();
                  accMap.put(a.CreatedByID, accWrap);
                  accWrap.userId=a.CreatedById;
               }
               accWrap.accounts.add(a);
             }
               wrapList=accMap.values();  */
                       
              MBT_SFFB__Facebook_Page__c objfbpage = [select ID,MBT_SFFB__Facebook_ID__c,MBT_SFFB__Facebook_Page_ID__c,MBT_SFFB__Facebook_Page_Name__c,MBT_SFFB__Image__c,MBT_SFFB__Facebook_Page_Url__c from MBT_SFFB__Facebook_Page__c where MBT_SFFB__Facebook_Page_ID__c=:pageid limit 1];
              objpostlist =[select Id,Name,MBT_SFFB__Author_External_Id__c,MBT_SFFB__Author_Realname__c,MBT_SFFB__Author_URL__c,MBT_SFFB__Collected_Comments__c,MBT_SFFB__Contact_Created__c,MBT_SFFB__Conversation_Contact__c,MBT_SFFB__External_ID__c,MBT_SFFB__Facebook_Page__c,MBT_SFFB__Is_Comment__c,MBT_SFFB__Likes_Count__c,MBT_SFFB__Link__c,MBT_SFFB__Message__c,MBT_SFFB__Paging__c,MBT_SFFB__parent__c,MBT_SFFB__Post_And_Comment_Retrieved_From__c,MBT_SFFB__Post_And_Comment_Retrieved_Untill__c,MBT_SFFB__Profile_Type__c,MBT_SFFB__Published_Date__c,MBT_SFFB__Replied_Conversation_s_External_Id__c,MBT_SFFB__Replied_User_s_External_Id__c,MBT_SFFB__Total_Comments__c,MBT_SFFB__Uncollected_Comments__c FROM MBT_SFFB__Conversation__c where MBT_SFFB__Is_Comment__c=:false and MBT_SFFB__Is_Status__c=:true];
              objcommentlist =[select Id,Name,MBT_SFFB__Author_External_Id__c,MBT_SFFB__Author_Realname__c,MBT_SFFB__Author_URL__c,MBT_SFFB__Collected_Comments__c,MBT_SFFB__Contact_Created__c,MBT_SFFB__Conversation_Contact__c,MBT_SFFB__External_ID__c,MBT_SFFB__Facebook_Page__c,MBT_SFFB__Is_Comment__c,MBT_SFFB__Likes_Count__c,MBT_SFFB__Link__c,MBT_SFFB__Message__c,MBT_SFFB__Paging__c,MBT_SFFB__parent__c,MBT_SFFB__parent__r.Id,MBT_SFFB__Post_And_Comment_Retrieved_From__c,MBT_SFFB__Post_And_Comment_Retrieved_Untill__c,MBT_SFFB__Profile_Type__c,MBT_SFFB__Published_Date__c,MBT_SFFB__Replied_Conversation_s_External_Id__c,MBT_SFFB__Replied_User_s_External_Id__c,MBT_SFFB__Total_Comments__c,MBT_SFFB__Uncollected_Comments__c FROM MBT_SFFB__Conversation__c where MBT_SFFB__Is_Comment__c=:true and MBT_SFFB__Is_Status__c=:true];
              for(MBT_SFFB__Conversation__c  objpost: objpostlist)
              {
                  //System.Debug(objpost);
                  
                  List<MBT_SFFB__Conversation__c> objcommentlists = new List<MBT_SFFB__Conversation__c>();
                   objmappost.put(objpost.Id,objpost);
                  for(MBT_SFFB__Conversation__c  objcomment: objcommentlist )
                  {                      
                      if(objpost.Id==objcomment.MBT_SFFB__parent__c)
                      {
                          objcommentlists.add(objcomment);                         
                      }
                     // System.Debug(objcomment);
                  }
                  if(objcommentlists.size()>0) 
                  {
                       objmapcomment.put(objpost.Id,objcommentlists);
                  }
                  else
                  {
                    //  objmapcomment.put(,null);
                  }                
              }              
              if(objfbpage!=null)
              {
                  pagename=objfbpage.MBT_SFFB__Facebook_Page_Name__c;
                  pagepicture=objfbpage.MBT_SFFB__Image__c;
                  pageurl=objfbpage.MBT_SFFB__Facebook_Page_Url__c;
                  
              }
              else
              {
                  pagename='Invalid Page ID';
                  pagepicture='';
              }              
              
         } 
                 
    }
    public pagereference postit()
    {
    String pgp =pagepost;
        if((pgp!=null)&&(pgp!='')&&(pgp!=' '))
        {
            
        }
        else
        {
        
        }
        return null;
    }
    public list<postandcommentswrapper> getposts()
   {
      return wraplist;
   }
   public PageReference createcontactifnot()
   {
       // query for the ID for child conversation grab auther ids and names. check in the contacts if exist or not 
       list<MBT_SFFB__Conversation__c> childconversation = new list<MBT_SFFB__Conversation__c>([select MBT_SFFB__External_ID__c,MBT_SFFB__Author_External_Id__c,MBT_SFFB__Image__c,MBT_SFFB__Author_URL__c,MBT_SFFB__Author_Realname__c from MBT_SFFB__Conversation__c where MBT_SFFB__parent__c=:postid and MBT_SFFB__Is_Comment__c=:true and MBT_SFFB__Author_External_Id__c!=:pageid  and MBT_SFFB__Is_Status__c=:true]);
        list<MBT_SFFB__Conversation__c> childconversationtoupdate = new list<MBT_SFFB__Conversation__c>();
       list<contact> listcontactfrompost = new list<contact>();
       Account acc = [select Id,Name from Account where Name='Social Account' limit 1];
       Set<String> contactfacebookid = new Set<String>();
       for(Contact c : [Select MBT_SFFB__Facebook_Id__c,MBT_SFFB__Username__c from contact])
       {
            contactfacebookid.add(c.MBT_SFFB__Facebook_Id__c);       
       }
      // contact cforegnkey = new contact();
       if(childconversation.size()>0)
       {
            for(MBT_SFFB__Conversation__c objchildconversation :childconversation)
            {
                if(!(contactfacebookid.contains(objchildconversation.MBT_SFFB__Author_External_Id__c)))
                {
                    // create contacts
                    childconversationtoupdate.add(objchildconversation);
                    if(String.valueOf(objchildconversation.MBT_SFFB__Author_Realname__c).containsAny(' '))
                    {
                        list<String> s = String.valueOf(objchildconversation.MBT_SFFB__Author_Realname__c).split(' ', 2);
                        
                        contact cnew = new contact(FirstName=String.valueOf(s[0]),LastName=String.valueOf(s[1]),MBT_SFFB__Facebook_Id__c=objchildconversation.MBT_SFFB__Author_External_Id__c,MBT_SFFB__Image__c=objchildconversation.MBT_SFFB__Image__c, MBT_SFFB__Profile_Url__c=objchildconversation.MBT_SFFB__Author_URL__c);
                    listcontactfrompost.add(cnew);
                        
                    }
                    else
                    {
                            contact cnew = new contact(LastName=String.valueOf(objchildconversation.MBT_SFFB__Author_Realname__c),MBT_SFFB__Facebook_Id__c=objchildconversation.MBT_SFFB__Author_External_Id__c,MBT_SFFB__Image__c=objchildconversation.MBT_SFFB__Image__c, MBT_SFFB__Profile_Url__c=objchildconversation.MBT_SFFB__Author_URL__c);
                    listcontactfrompost.add(cnew);
                    }
                    
                    
                }
                
            }   
       }
       list<MBT_SFFB__Conversation__c> listoflookupadd = new list<MBT_SFFB__Conversation__c>(); 
       
       if(listcontactfrompost.size()>0)
       {
           insert listcontactfrompost;
           list<contact> contactlist = new list<contact>([select Id,Name,MBT_SFFB__Facebook_Id__c from contact where MBT_SFFB__Facebook_Id__c !=:null]);
           if(childconversationtoupdate.size()>0)
           {
               
               for(MBT_SFFB__Conversation__c objchildconversation :childconversationtoupdate)
               {
                   for(contact c: contactlist)
                   {
                       if(c.MBT_SFFB__Facebook_Id__c==objchildconversation.MBT_SFFB__Author_External_Id__c)
                       {
                        objchildconversation.MBT_SFFB__Conversation_Contact__c =c.id;
                         listoflookupadd.add(objchildconversation);
                       }
                   }
               }
           }
           if(listoflookupadd.size()>0)
           {
               update listoflookupadd;
           }
       }
     contactbind();
       
       return null;
   }
   public void contactbind()
   {
     contactlistbypage = new list<MBT_SFFB__Conversation__c>();
      pageid =ApexPages.currentPage().getParameters().get('page');
      list<MBT_SFFB__Conversation__c> objconversations = new list<MBT_SFFB__Conversation__c>();
      String pgid='';
      if(pageid!=null)
      {
          list<MBT_SFFB__Facebook_Page__c> objlstpage = new list<MBT_SFFB__Facebook_Page__c>([select Id,Name,MBT_SFFB__Facebook_Page_ID__c,MBT_SFFB__Facebook_Page_Name__c from MBT_SFFB__Facebook_Page__c where MBT_SFFB__Facebook_Page_ID__c=:pageid]);
          if(objlstpage.size()>0)
          {
              for(MBT_SFFB__Facebook_Page__c objpage :objlstpage)
              {
                  pgid= objpage.Id;
                 
              }
          }
          if(pgid!='')
          {
               for(MBT_SFFB__Conversation__c objconversation :[select MBT_SFFB__Author_External_Id__c,MBT_SFFB__Author_Realname__c,MBT_SFFB__Author_URL__c,MBT_SFFB__Conversation_Contact__c,MBT_SFFB__Conversation_Contact__r.Name,MBT_SFFB__Conversation_Contact__r.Email from MBT_SFFB__Conversation__c  where MBT_SFFB__Facebook_Page__c =:pgid and MBT_SFFB__Conversation_Contact__c!=:null])
               {
                   objconversations.add(objconversation);
               }
              
          }
          if(objconversations.size()>0)
          {
              contactlistbypage=objconversations;
          }
          
      }
   }
    public List<Map<String,Object>> Mapwithpostandcomments(){
    
    List<Map<String,MBT_SFFB__Conversation__c>> resultList = new List<Map<String,MBT_SFFB__Conversation__c>>();

   // List<List<Object>> resultList = new List<List<Object>>(); // your result list of lists
   /* for(Map<String,Object> m : )
    {
        List<Object> myTupple = new List<Object>();
        for (Integer key : m.keySet()) 
        {
            myTupple.Add(m.get(key));
        }
        resultList.Add(myTupple);
    }*/

    return resultList;
  }
  public class postandcommentswrapper
{

public List<MBT_SFFB__Conversation__c> masterconversations {get; set;}
    public postandcommentswrapper()
    {
        // default constructor
        masterconversations =new List<MBT_SFFB__Conversation__c>();
        
    }
}
}