class Office {
  Office({
    this.id,
    this.name,
    this.address,
    this.email,
    this.phone,
    this.message1,
    this.message2,
    this.message3,
    this.photoUrl,
    this.owner,
  });
  final String id;
  final String name;
  final String address;
  final String email;
  final String phone;
  final String message1;
  final String message2;
  final String message3;
  final String owner;
  String photoUrl;

  factory Office.fromMap(Map data, String documentID) {
    data = data ?? {};
    return Office(
      id: documentID,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      message1: data['message1'] ?? '',
      message2: data['message2'] ?? '',
      message3: data['message3'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      owner: data["owner"] ?? '',
    );
  }

  toJsonUpdate() {
    return {
      "name": name,
      "address": address ?? '',
      "email": email ?? '',
      "message1": message1 ?? '',
      "message2": message2 ?? '',
      "message3": message3 ?? '',
      "photoUrl": photoUrl ?? ''
    };
  }

  bool equalsTo(Office officeToCompare) {
    if (this.id == officeToCompare.id &&
        this.name == officeToCompare.name &&
        this.address == officeToCompare.address &&
        this.email == officeToCompare.email &&
        this.message1 == officeToCompare.message1 &&
        this.message2 == officeToCompare.message2 &&
        this.message3 == officeToCompare.message3) return true;

    return false;
  }
}
