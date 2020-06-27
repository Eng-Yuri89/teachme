import 'package:cloud_firestore/cloud_firestore.dart';

class Profile{
  Profile({
    this.id,
    this.email,
    this.photoUrl,
    this.firstName,
    this.lastName,
    this.devicetoken,
    this.phonenumber,
    this.status,
    this.endtrial
  });

  final String id;
  final String email;
  String photoUrl;
  final String firstName;
  final String lastName;
  final String devicetoken;
  final String phonenumber;
  final String status;
  final Timestamp endtrial;

  factory Profile.fromMap(Map data, String documentID) {
    data = data ?? { };
    return Profile(
      id: documentID,
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      firstName : data['firstname'] ?? '',
      lastName: data['lastname'] ?? '',
      devicetoken: data['devicetoken'] ?? '',
      phonenumber: data['phonenumber'] ?? '',
      status: data['status'] ?? '',
      endtrial: data['endtrial'] ?? new Timestamp(10, 10),
    );
  }

  toJson() {
    return {
      "firstname": firstName,
      "lastname": lastName ?? '',
    };
  }

  toJsonUpdate() {
    return {
      "firstname": firstName,
      "lastname": lastName ?? '',
      "phonenumber": phonenumber ?? '',
      "photoUrl": photoUrl ?? ''
    };
  }

  toJsonUpdateStatus() {
    return {
      "status": status
    };
  }

  deviceTokenToJson() {
    return {
      "devicetoken": devicetoken,
    };
  }

  bool equalsTo(Profile profileToCompare){
    if (this.id == profileToCompare.id &&
      this.firstName == profileToCompare.firstName &&
      this.lastName == profileToCompare.lastName &&
      this.phonenumber == profileToCompare.phonenumber)
      return true;
    
    return false;
  }
  
}