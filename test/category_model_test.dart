import 'package:flutter_test/flutter_test.dart';
import 'package:local_express/models/category_model.dart';

void main() {
  test('CategoryModel fromJson handles null values properly', () {
    // Test with null values
    final json1 = {
      'id': 'test1',
      'name': null,
      'description': null,
      'icon': null,
      'color': null,
      'createdAt': null,
    };
    
    final category1 = CategoryModel.fromJson(json1);
    expect(category1.id, 'test1');
    expect(category1.name, '');
    expect(category1.description, '');
    
    // Test with valid values
    final json2 = {
      'id': 'test2',
      'name': 'Test Category',
      'description': 'Test Description',
      'icon': 58718, // Icons.category codePoint
      'color': 4280391411, // Colors.blue value
      'createdAt': '2025-08-22T10:00:00.000Z',
    };
    
    final category2 = CategoryModel.fromJson(json2);
    expect(category2.id, 'test2');
    expect(category2.name, 'Test Category');
    expect(category2.description, 'Test Description');
  });
}
