class RecFood {
  final String name;
  final double calories;
  final double sodiumContent;
  final double carbohydrateContent;
  final double sugarContent;
  final String type;

  RecFood({
    required this.name,
    required this.calories,
    required this.sodiumContent,
    required this.carbohydrateContent,
    required this.sugarContent,
    required this.type,
  });

  factory RecFood.fromJson(Map<String, dynamic> json) {
    RecFood feature= RecFood(
      name: json['Name'] as String,
      calories: (json['Calories'] as num).toDouble(),
      sodiumContent: (json['SodiumContent'] as num).toDouble(),
      carbohydrateContent: (json['CarbohydrateContent'] as num).toDouble(),
      sugarContent: (json['SugarContent'] as num).toDouble(),
      type: json['type'] as String,
    );
    return feature;
  }
}