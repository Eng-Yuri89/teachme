class Status {
  // Status indicator.
  final String status;

  Status({this.status});

  factory Status.fromMap(Map<String, dynamic> data) {
    return Status(status: data["name"] ?? "");
  }
}
