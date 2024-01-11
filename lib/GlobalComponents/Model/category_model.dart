class CategoryModel {
  late String categoryName;
  late String categoryimage;
  late bool size;
  late bool color;
  late bool weight;
  late bool capacity;
  late bool type;

  CategoryModel({
    required this.categoryName,
    required this.categoryimage,
    required this.size,
    required this.color,
    required this.capacity,
    required this.type,
    required this.weight,
  });

  CategoryModel.fromJson(Map<dynamic, dynamic> json) {
    categoryName = json['categoryName'] as String;
    categoryimage = json['categoryImage'] as String;
    size = json['variationSize'] as bool;
    color = json['variationColor'] as bool;
    capacity = json['variationCapacity'] as bool;
    type = json['variationType'] as bool;
    weight = json['variationWeight'] as bool;
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'categoryName': categoryName,
        'categoryImage': categoryimage,
        'variationSize': size,
        'variationColor': color,
        'variationCapacity': capacity,
        'variationType': type,
        'variationWeight': weight,
      };
}

class GetCategoryAndVariationModel {
  GetCategoryAndVariationModel(
      {required this.categoryName, required this.variations});

  final String categoryName;
  final List<String> variations;
}
