class KeyStore{
  String getKey(){
    return "AIzaSyB26lw0PCHvkFrtc81z6vbFs0KT2MYd0eQ";
  }
  String getPromptHelp(String message){
    String details=""
        ;
    if(message.contains("diet")){
      details+="\n";
    }
    return details;
  }
}