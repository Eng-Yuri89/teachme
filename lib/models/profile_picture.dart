class Picture {
  Picture(this.downloadUrl);
  final String downloadUrl;

  factory Picture.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String downloadUrl = data['downloadUrl'];
    if (downloadUrl == null) {
      return null;
    }
    return Picture(downloadUrl);
  }

  Map<String, dynamic> toMap() {
    return {
      'downloadUrl': downloadUrl,
    };
  }
}