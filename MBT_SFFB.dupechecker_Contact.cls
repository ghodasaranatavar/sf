/**
@author Innodel Technologies PVT LTD
@date 21 th OCT 2016
@description Checkes duplicate and insert Contact if record not Exist.
*/
global class dupechecker_Contact
{
    public String contactName { get; set; }
    public String contactEmail { get; set; }
    public String contactPhone { get; set; }
    public Contact objcontactref {get;set;}
    public static Contact newcontact { get; set; }
    public static List<Contact> contact { get; set; }
    public static ID ContactID { get; set; }
    public static String ContactnewName { get; set; }
    public static Integer noofcontact { get; set; }
    public static boolean emptyContactList { get; set; }
    public static boolean noContactResult { get; set; }
    public dupechecker_Contact(ApexPages.StandardController con) {           
         objcontactref = new Contact();
           
    }
     /**
@date 21 th OCT 2016
@description Inserts Contact with params and returns ID in string format - JSremote method
@param contactName Name of Contact to insert
@param contactPhone Phone no of Contact to insert
@param contactEmail Email no of Contact to insert
*/
     @RemoteAction
    global static String insertContact(String contactName,String contactPhone,String contactEmail) 
    {
        try
        {
            newcontact= new Contact();
            newcontact.LastName =contactName;
            newcontact.MobilePhone=contactPhone;
            newcontact.Email=contactEmail;
            insert newcontact;
            return String.valueOf(newcontact.id);

        }
    catch (Exception ex)
    {
       return 'Exception';
    }
        
        
    }
    /**
@date 21 th OCT 2016
@description Searches returns List<Contact>  - JSremote method
@param contactName Name of Contact to search
@param contactPhone Phone no of Contact to search
@param contactEmail Email no of Contact to search
*/
    @RemoteAction
    global static List<Contact> getContact(String contactName ,String contactPhone,String contactEmail) 
    {
        noofcontact =0;
        
         if((!(String.isBlank(contactName)))&&(!(String.isBlank(contactPhone)))&&(!(String.isBlank(contactEmail))))
         {
        // contactName='%'+contactName+'%';
       // contactPhone='%'+contactPhone+'%';
       // contactEmail='%'+contactEmail+'%';
            contact=[select ID,Name,MobilePhone,Email from Contact where FirstName =: contactName OR MobilePhone =: contactPhone OR Email =: contactEmail];
         }
         else if(((String.isBlank(contactName)))&&(!(String.isBlank(contactPhone)))&&(!(String.isBlank(contactEmail))))
         {

       // contactPhone='%'+contactPhone+'%';
       // contactEmail='%'+contactEmail+'%';
            contact=[select ID,Name,MobilePhone,Email from Contact where MobilePhone =: contactPhone OR Email =: contactEmail];
         }
         else if((!(String.isBlank(contactName)))&&((String.isBlank(contactPhone)))&&(!(String.isBlank(contactEmail))))
         {
        // contactName='%'+contactName+'%';
      //  contactEmail='%'+contactEmail+'%';
            contact=[select ID,Name,MobilePhone,Email from Contact where FirstName =: contactName OR Email =: contactEmail];
         }
         else if((!(String.isBlank(contactName)))&&(!(String.isBlank(contactPhone)))&&((String.isBlank(contactEmail))))
         {
     //    contactName='%'+contactName+'%';
      //  contactPhone='%'+contactPhone+'%';

            contact=[select ID,Name,MobilePhone,Email from Contact where FirstName =: contactName OR MobilePhone =: contactPhone];
         }
         else if((!(String.isBlank(contactName)))&&((String.isBlank(contactPhone)))&&((String.isBlank(contactEmail))))
         {
       //  contactName='%'+contactName+'%';

            contact=[select ID,Name,MobilePhone,Email from Contact where FirstName  =: contactName];
         }
         else if(((String.isBlank(contactName)))&&(!(String.isBlank(contactPhone)))&&((String.isBlank(contactEmail))))
         {

        //contactPhone='%'+contactPhone+'%';
  
            contact=[select ID,Name,MobilePhone,Email from Contact where MobilePhone  =: contactPhone];
         }
         else if(((String.isBlank(contactName)))&&((String.isBlank(contactPhone)))&&(!(String.isBlank(contactEmail))))
         {

       // contactEmail='%'+contactEmail+'%';
            contact=[select ID,Name,MobilePhone,Email from Contact where Email =: contactEmail];
         }
         noofcontact=contact.size();
         emptyContactList = contact.isEmpty() ? true : false;
         noContactResult=emptyContactList;
        return contact;
    }
}