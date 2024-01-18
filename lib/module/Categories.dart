class Categories {
  final String name;

  Categories({required this.name});
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Categories && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
