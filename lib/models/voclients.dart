/// veoclients table db model
class VOClients {
  final String id;
  final String office;

  VOClients({this.id, this.office});

  factory VOClients.fromMap(Map<String, dynamic> data, String documentId) {
    return VOClients(
      id : documentId ?? "",
      office: data["office"] ?? ""
    );
  }
}