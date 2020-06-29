class TeacherFavorite {
  final String teacher;
  final String user;
  final String id;

  TeacherFavorite({
    this.teacher,
    this.user,
    this.id,
  });

  factory TeacherFavorite.fromMap(
      Map<String, dynamic> data, String documentId) {
    return TeacherFavorite(
      teacher: data["teacher"] ?? "",
      user: data["user"] ?? "",
      id: documentId ?? "",
    );
  }
}
