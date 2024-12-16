class Country {
  final String strArea;

  Country({required this.strArea});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      strArea: json['strArea'],
    );
  }
}