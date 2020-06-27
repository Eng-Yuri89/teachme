/// Database model for the
/// handleoptions collecion
class HandleOption {
  // Option to take for the package.
  final String option;

  HandleOption({this.option});

  factory HandleOption.fromMap(Map<String, dynamic> data) {
    return HandleOption(
      option: data["option"] ?? "",
    );
  }
}
