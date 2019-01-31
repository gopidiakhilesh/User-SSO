global class GoogleOAuth {
    
  public string OAuthUri='';
    
  global GoogleOAuth(String ClientID,String redirectURI){
      OAuthUri='https://accounts.google.com/o/oauth2/v2/auth?'+
          'scope=https://www.googleapis.com/auth/youtube&'+
          'access_type=offline&include_granted_scopes=true&'+
          'state=1234&'+
          'redirect_uri='+redirectURI+
          '&response_type=code&'+
          'client_id='+ClientID;
      
  }

}