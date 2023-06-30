class BrandModel {
  String? id_brand;
  String? brand;

  BrandModel({this.id_brand, this.brand});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id_brand: json['id_brand'],
      brand: json['brand'],
    );
  }
}
