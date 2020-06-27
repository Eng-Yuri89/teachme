class FirestorePath {
  static String avatar(String id) => 'avatar/$id';
  static String package(String id) => 'packages/$id';
  static String office(String id) => 'offices/$id';
  static String mail(String id) => 'mails/$id';
  static String getPath(String type, String id) {
    if(type == 'profile'){
      return avatar(id);
    } 
    else if(type == 'mail'){
      return package(id);
    }
    else if(type == 'office'){
      return office(id);
    }
    else{
      return mail(id);
    }
  }
}