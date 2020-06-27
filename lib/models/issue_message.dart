/// Database model class for
/// issue message
class IssueMessage {
  // Issue
  final String issue;

  IssueMessage({this.issue});

  factory IssueMessage.fromMap(Map<String, dynamic> data) {
    return IssueMessage(
      issue: data["issue"] ?? "",
    );
  }
}
