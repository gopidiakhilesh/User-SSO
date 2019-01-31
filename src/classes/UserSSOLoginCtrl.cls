public class UserSSOLoginCtrl {
    
    Private Map<String,SSOCredentails__c> mapSSODetails = SSOCredentails__c.getAll();
    public string ClientID = mapSSODetails.get('Google').Client_Id__c;
    public string redirectUri = mapSSODetails.get('Google').RedirectUrl__c;
    public string ClientSecret = mapSSODetails.get('Google').Client_Secret__c;
    private string responseBody;
    private string IdentificationToken;
    private string accessToken;
    private static string UserId;
    public UserSSOLoginCtrl(){
        IdentificationToken=ApexPages.CurrentPage().getParameters().get('code');
        if(IdentificationToken!=null){
            authenticateWithGoogle();
        }
    }
     
     public pageReference GoogleSSOConnect(){
        pageReference p=new pageReference(new GoogleOAuth(ClientID,redirectUri).OAuthUri);
        return p;
    }
   
    public string GoogleAuthorizationCode()
    {
        HttpRequest req=new HttpRequest();
        String AuthorizationEndpointURL =  mapSSODetails.get('Google').AccessTokenUrl__c;
        String AuthorizationMethod  = mapSSODetails.get('Google').AccessTokenMethod__c;
        req.setEndpoint(AuthorizationEndpointURL);
        req.setMethod(AuthorizationMethod);
        req.setHeader('content-type','application/x-www-form-urlencoded');
        String b='code='+IdentificationToken+'&client_id='+ClientID+'&client_secret='+ClientSecret+'&redirect_uri='+redirectUri+'&grant_type=authorization_code';
        req.setBody(b);
        Http ht=new Http();
        HttpResponse res=ht.send(req);
        string body=res.getBody();
        UserDetailsResponse.accessTokenGenerator accessTokenResponse =(UserDetailsResponse.accessTokenGenerator)JSON.deserialize(body,UserDetailsResponse.accessTokenGenerator.class);
        accessToken = accessTokenResponse.access_Token;
        return accessToken;
    }
    
    public pageReference authenticateWithGoogle(){
        if(string.isNotEmpty(IdentificationToken)){
            string accessToken = GoogleAuthorizationCode();
            String EndpointURL =  mapSSODetails.get('Google').EndpointUrl__c ;
            String SearchMethod  = mapSSODetails.get('Google').SearchMethod__c;
            HttpRequest req = new HttpRequest();
            req.setEndpoint(EndpointURL);
            req.setMethod(SearchMethod);
            req.setHeader('content-type','application/json');
            req.setHeader('Authorization','Bearer ' + accessToken);
            Http ht = new Http();
            HttpResponse res  = ht.send(req);
            responseBody = res.getBody();
            UserDetailsResponse.UserPersonalInfo infoResponse = (UserDetailsResponse.UserPersonalInfo)JSON.deserialize(responseBody, UserDetailsResponse.UserPersonalInfo.class);
            string resourceId  =  infoResponse.names[0].metadata.source.id;
            string displayName  =  infoResponse.names[0].displayName;
            system.debug('ResourceId:: '+resourceId);
            system.debug('DisplayName:: '+displayName);
            List<UserDetails__c> UserLoginDetails = fetchUserDetails(resourceId);
            pageReference p = new pageReference('/apex/UserLandingPage');
            p.getParameters().put('resourceId',resourceId); 
            p.setRedirect(true);                                                     
            if(UserLoginDetails.isEmpty()){
                CreateUserDetails(displayName,resourceId);
                p.getParameters().put('id',UserId);
            }
            else{
                p.getParameters().put('id',UserLoginDetails[0].id);
                
            }
            return p; 
        }
        return null;
    }
    
    @future
    public static void CreateUserDetails(String displayName, String resourceId){
        UserDetails__c userDetails = new UserDetails__c();
        userDetails.DisplayName__c = displayName;
        userDetails.ResourceId__c = resourceId;
        userDetails.Source__c = 'Google';
        insert userDetails;
        UserId  = userDetails.Id;
    }
    
    private List<UserDetails__c> fetchUserDetails(string resourceId){
        List<UserDetails__c> UserLoginDetails  = [SELECT id,DisplayName__c,ResourceId__c,Source__c 
                                                      FROM UserDetails__c 
                                                      WHERE ResourceId__c=:resourceId];
        return UserLoginDetails;
    }
    
    
    
}