import 'package:cloud_firestore/cloud_firestore.dart';

class Mail {
  final String id;
  final Timestamp dateTime;
  final String office;
  final String owner;
  final String packageid;
  final String description;
  final Package package1;
  final Package package2;
  final Package package3;
  final Package package4;
  String status;
  String signature;
  String ownerName;

  Mail({
    this.id,
    this.dateTime,
    this.office,
    this.owner,
    this.packageid,
    this.description,
    this.package1,
    this.package2,
    this.package3,
    this.package4,
    this.status,
    this.signature,
    this.ownerName
  });

  factory Mail.fromMap(Map data, String documentID) {
    data = data ?? { };
    return Mail(
      id: documentID,
      dateTime: data['dateTime'] ?? Timestamp(0,0),
      owner: data['owner'] ?? '',
      ownerName: data['ownerName'] ?? '',
      office: data['office'] ?? '',
      packageid : data['packageid'] ?? '',
      status : data['status'] ?? '',
      description : data['description'] ?? '',
      package1: Package.fromMap(Map<String, dynamic>.from(data['package1']), documentID) ?? null,
      package2: Package.fromMap(Map<String, dynamic>.from(data['package2']), documentID) ?? null,
      package3: Package.fromMap(Map<String, dynamic>.from(data['package3']), documentID) ?? null,
      package4: Package.fromMap(Map<String, dynamic>.from(data['package4']), documentID) ?? null,
      signature: data['signature'] ?? '',
    );
  }

  toJsonUpdate() {
    return {
      "status": status,
      "signature": signature ?? '',
    };
  }
}

class Package
{
  String id;
  String imageUrl;
  String type;
  final bool storagecost;
  String action;
  String mailID;

  Package({
    this.imageUrl,
    this.storagecost,
    this.type,
    this.action,
    this.mailID,
    this.id
  });
  /// Mapping from Query Snapshot Firebase
  /// Getting data
  /// Matching data
  Package.fromMap(Map<String, dynamic> data, String id)
      : this(
      id: id,
      imageUrl: data['imageUrl'] ?? '',
      storagecost : data['storagecost'] ?? false,
      type : data['type'] ?? 'Test',
      action : data['action'] != "" ? data['action'] : "No Actions",
      mailID : data['mailID'] ?? ""
  );

  Map<String, dynamic> toMap()
  {
    var mapData = new Map();
    mapData["imageUrl"] = this.imageUrl;
    mapData["storagecost"] = this.storagecost;
    return mapData;

  }
}