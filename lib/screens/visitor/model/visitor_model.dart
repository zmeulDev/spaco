class VisitorModel {
  final String uid;
  final String? name;
  final String? company;
  final String? phone;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? appuser;

  VisitorModel(
      {required this.uid,
      this.name,
      required this.company,
      this.phone,
      this.checkIn,
      this.checkOut,
      this.appuser});

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      uid: json["uid"],
      name: json["name"],
      company: json["company"],
      phone: json["phone"],
      checkIn: json["checkin"],
      checkOut: json["checkout"],
      appuser: json["appuser"],
    );
  }

  static List<VisitorModel> fromJsonList(List list) {
    return list.map((item) => VisitorModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String visitorAsString() {
    return '#${this.uid} ${this.name}';
  }

  ///this method will prevent the override of toString
  bool visitorFilterByCreationDate(String filter) {
    return name.toString().contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(VisitorModel? model) {
    return this.name == model?.name;
  }

  @override
  String toString() => name!;
}
