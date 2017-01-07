global with sharing class facebookintegrationtest
{
    
    public string ownname {get;set;}
    public static string ownid {get;set;}
    public string ownemail {get;set;}
    public string ownformatedname{get;set;}
    global string ownphoto{get;set;}
    public string wellcomestring {get;set;}
    public string profilepic{get;set;}   
    public string shares{get;set;}
    @RemoteAction
    public static string gettoken(string code)
    {
        return facebookAPI.gotAccessTocken(code,'847444638724852','ca77d8f69d4d814967a1db93c8d2b6bf');
                      
    }
    @RemoteAction
    public static list<string> getmyprofiledata(string accesstoken)
    {        
       
       
     string prof =facebookAPI.getownprofile(accesstoken);     
     string name =facebookAPI.getownname(prof);     
    // string pic = facebookAPI.getownpicture(prof);     
         
     //ownphoto=pic;
     list<string> data = new list<string>();
     data.add(name);
     //data.add(pic);
    // data.add(pname);
    // data.add(pid);
    // data.add(paccesstoken);
    
     return data;              
        
    }
    @RemoteAction
    public static list<facebookpagelistapiclass.Data> getmypagelist(string accesstoken)
    {
        string profs =facebookAPI.getpage(accesstoken);
        facebookpagelistapiclass objfacebookpagelistapiclass = new facebookpagelistapiclass();
        objfacebookpagelistapiclass = facebookpagelistapiclass.parse(profs);
        list<facebookpagelistapiclass.Data> datalistobj =objfacebookpagelistapiclass.Accounts.data;
        //string size =string.valueof(datalistobj.size());
        /*list<string> pageList = new list<String>();
        JSONParser parser = JSON.createParser(profs);
        while (parser.nextToken() != null) 
        {          
            if((parser.getCurrentName() == 'name'))
            {
                parser.nextToken();    //We want the value, so advance to the next token.
                pageList.add(parser.getText());
            }
        }
        return pageList;*/
        return datalistobj;
    }
    @RemoteAction
    public static string getmypageid(string accesstoken,string pagename)
    {
        string profs =facebookAPI.getpage(accesstoken);
        string pid='';
        list<string> pageList = new list<String>();
        JSONParser parser = JSON.createParser(profs);
        while (parser.nextToken() != null) 
        {          
            if((parser.getCurrentName() == 'name'))
            {
                parser.nextToken();    //We want the value, so advance to the next token.
                if(parser.getText()==pagename)
                {
                    parser.nextToken();
                    if((parser.getCurrentName() == 'id'))
                    {
                         parser.nextToken();
                         pid=parser.getText();
                    }                    
                }                
            }
        }
        JSONParser parser2 = JSON.createParser(profs);
        while (parser2.nextToken() != null) 
        {          
            if((parser2.getCurrentName() == 'name'))
            {
                parser2.nextToken();    //We want the value, so advance to the next token.
                if(parser2.getText()==pagename)
                {
                    parser2.nextToken();
                    if((parser2.getCurrentName() == 'id'))
                    {
                         parser2.nextToken();
                         //pid=parser2.getText();
                    }                    
                }                
            }
        }
        return pid;
    }         
    @RemoteAction
    public static string postcomment(string post,string paccesstoken,string pid)
    {
        /*facebookpagecomment__c objfbcmnt = new facebookpagecomment__c();        
        objfbcmnt.post__c = post;
        objfbcmnt.facebookpageid__c='page-0001';
        insert objfbcmnt;
        return 'sucess';*/
        return facebookAPI.sharepostownprofile(post,pid,paccesstoken);
    }
    @RemoteAction
    public static list<facebookpagecomment__c> getposts(string id)
    {
        return [select comments__c,post__c from facebookpagecomment__c where facebookpageid__c =:id];
    }
    @RemoteAction
    public static list<string> getpostlist(string paccesstoken,string pid)
    {
        string pagepost = facebookAPI.getpagepost(paccesstoken,pid);
        list<string> messageList = new list<String>();
        JSONParser parser = JSON.createParser(pagepost);
        while (parser.nextToken() != null) 
        {          
            if((parser.getCurrentName() == 'story')||(parser.getCurrentName() == 'message'))
            {
                parser.nextToken();    //We want the value, so advance to the next token.
                messageList.add(parser.getText());
            }
        }
        return messageList;
       /* facebookpagepostlistapi objfacebookpagepostlistapi = new facebookpagepostlistapi();
        objfacebookpagepostlistapi =facebookpagepostlistapi.parse(pagepost);
        list<facebookpagepostlistapi.Data> objdata =objfacebookpagepostlistapi.feed.data;
        list<string> sdata = new list<string>();*/
        
       /* if(objdata!=null)
        {
            for (facebookpagepostlistapi.Data item : objdata) 
            {
            sdata.add(item.story);
            }
            
        }
        return sdata;*/
        /*list<string> sdata = new list<string>();
         Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(pagepost);
        List<Object> items = (List<Object>)root.get('data');*/
          
        //return (List<String>)System.JSON.deserialize(pagepost , List<String>.class);
        /*Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(pagepost);
        List<Object> items = (List<Object>)root.get('Data'); 
        list<string> sdata = new list<string>();
        map<string,string> newMap= new Map<string,string>();
         for (Object item : items) 
        {
            Map<String, Object> i = (Map<String, Object>)item;
           
        for(String strKey: i.keyset())
        {
            newMap.put(strKey, String.valueof(i.get(strKey)));
        }
          //  sdata.add(i.get('message').);
        }*/
            
        
    }
    
   /* public static list<Object> parsedata(string jsonstring) 
    {
        // returns primary account
        Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(jsonstring);
        List<Object> items = (List<Object>)root.get('Data');        
        return items;
    } */ 
}