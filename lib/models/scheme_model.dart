class SchemeModel {
  final String id;
  final String name;
  final String? description;
  final String? eligibility;
  final String? benefits;

  SchemeModel({
    required this.id,
    required this.name,
    this.description,
    this.eligibility,
    this.benefits,
  });

  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    return SchemeModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'],
      eligibility: json['eligibility'],
      benefits: json['benefits'],
    );
  }
}
