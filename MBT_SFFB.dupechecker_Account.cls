/**
@author Innodel Technologies PVT LTD
@date 21 th OCT 2016
@description Checkes duplicate and insert Account if record not Exist.
*/
global class dupechecker_Account
{
public String accountName { get; set; }
    
    public String accountPhone { get; set; }
    public Account objaccountref {get;set;}
    public static Account newaccount { get; set; }
    public static List<Account> account { get; set; }
    public static ID AccountID { get; set; }
    public static String AccountnewName { get; set; }
    public static Integer noofaccount { get; set; }
    public static boolean emptyAccountList { get; set; }
    public static boolean noAccountResult { get; set; }
    public dupechecker_Account(ApexPages.StandardController acc) {           
         objaccountref= new Account();
           
    }
      /**
@date 21 th OCT 2016
@description Inserts Account with params and returns ID in string format - JSremote method
@param accountName Name of Account to insert
@param accountPhone Phone no of Account to insert
*/
     @RemoteAction
    global static String insertAccount(String accountName,String accountPhone ) 
    {
        try
        {
            newaccount= new Account();
            newaccount.Name=accountName;
            newaccount.Phone=accountPhone;
            
            insert newaccount;
            return String.valueOf(newaccount.id);

        }
    catch (Exception ex)
    {
       return 'Exception';
    }
        
        
    }
     /**
@date 21 th OCT 2016
@description Searches returns List<Account> - JSremote method
@param accountName Name of account to search
@param accountPhone Phone no of account to search
*/
    @RemoteAction
    global static List<Account> getAccount(String accountName,String accountPhone) 
    {
        noofaccount =0;
        
         if((!(String.isBlank(accountName)))&&(!(String.isBlank(accountPhone))))
         {
         accountName=accountName+'%';
        accountPhone=accountPhone+'%';
        
            account=[select ID,Name,Phone,BillingCountry,BillingCity from Account where Name LIKE: accountName OR Phone LIKE: accountPhone ORDER BY Name];
         }
         else if(((String.isBlank(accountName)))&&(!(String.isBlank(accountPhone))))
         {

        accountPhone=accountPhone+'%';
       
            account=[select ID,Name,Phone,BillingCountry,BillingCity from Account where Phone LIKE: accountPhone ORDER BY Name];
         }
         else if((!(String.isBlank(accountName)))&&((String.isBlank(accountPhone))))
         {
         accountName=accountName+'%';
        
            account=[select ID,Name,Phone,BillingCountry,BillingCity from Account where Name LIKE: accountName ORDER BY Name];
         }
                  noofaccount=account.size();
         emptyAccountList= account.isEmpty() ? true : false;
         noAccountResult =emptyAccountList;
        return account;
    } 
}