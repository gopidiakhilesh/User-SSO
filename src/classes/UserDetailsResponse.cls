public class UserDetailsResponse {
    
    public class UserPersonalInfo{
        public String resourceName; //people/106452211227304310962
        public String etag; //%EgsBAj0HCAk+EEA3LhoMAQIDBAUGBwgJCgsM
        public cls_names[] names;
        public cls_birthdays[] birthdays;
        public cls_emailAddresses[] emailAddresses;
    }
    public class cls_names {
        public cls_metadata metadata;
        public String displayName;  
        public String familyName;   
        public String givenName;    
        public String displayNameLastFirst; 
    }
    public class cls_metadata {
        public boolean primary;
        public boolean verified;
        public cls_source source;
    }
    public class cls_source {
        public String type; //ACCOUNT
        public String id;   //106452211227304310962
    }
    public class cls_birthdays {
        public cls_metadata metadata;
        public cls_date dates;
    }
    public class cls_date {
        public Integer year;    
        public Integer month;   
        public Integer day; 
    }
    public class cls_emailAddresses {
        public cls_metadata metadata;
        public String value;    
    }
    
    public class accessTokenGenerator
    {
        public string access_token{get;set;} 
    }

}