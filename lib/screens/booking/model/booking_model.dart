class BookingModel {
  final String uid;
  final String? appuser;
  final DateTime? book_from;
  final DateTime? book_to;
  final String? name;
  final String? room;
  final String? uploaded_time;

  BookingModel(
      {required this.uid,
      this.appuser,
      required this.book_from,
      this.book_to,
      this.name,
      this.room,
      this.uploaded_time});

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      uid: json["uid"],
      appuser: json["appuser"],
      book_from: json["book_from"],
      book_to: json["book_to"],
      name: json["name"],
      room: json["room"],
      uploaded_time: json["uploaded_time"],
    );
  }

  static List<BookingModel> fromJsonList(List list) {
    return list.map((item) => BookingModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String bookingAsString() {
    return '#${this.uid} ${this.name}';
  }

  ///this method will prevent the override of toString
  bool visitorFilterByCreationDate(String filter) {
    return name.toString().contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(BookingModel? model) {
    return this.name == model?.name;
  }

  @override
  String toString() => name!;
}
