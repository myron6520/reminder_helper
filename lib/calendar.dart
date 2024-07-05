class Calendar {
  late String id;
  late String title;
  Calendar.fromMap(Map info) {
    id = "${info['id'] ?? ''}";
    title = "${info['title'] ?? ''}";
  }
}
