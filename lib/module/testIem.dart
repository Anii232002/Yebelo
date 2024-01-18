class TestItem {
  final String name;
  final int id;
  final int cost;
  final int availability;
  final String details;
  final String category;

  const TestItem({
    required this.name,
    required this.id,
    required this.cost,
    required this.availability,
    required this.details,
    required this.category,
  });

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(
      id: (json.containsKey('p_id')) ? json['p_id'] as int : 0,
      name: (json.containsKey('p_name')) ? json['p_name'] as String : 'null',
      cost: (json.containsKey('p_cost')) ? json['p_cost'] as int : 0,
      availability: (json.containsKey('p_availability'))
          ? json['p_availability'] as int
          : 0,
      details: (json.containsKey('p_details'))
          ? json['p_details'] as String
          : 'null',
      category: (json.containsKey('p_category'))
          ? json['p_category'] as String
          : 'null',
    );
  }
}
