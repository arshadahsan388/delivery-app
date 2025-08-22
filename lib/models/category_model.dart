import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final DateTime createdAt;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.createdAt,
    this.isActive = true,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    Color? color,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon.codePoint,
      'color': color.value,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] != null 
          ? IconData(
              json['icon'] is int 
                  ? json['icon'] 
                  : int.tryParse(json['icon'].toString()) ?? Icons.category.codePoint,
              fontFamily: 'MaterialIcons'
            )
          : Icons.category,
      color: json['color'] != null 
          ? Color(
              json['color'] is int 
                  ? json['color'] 
                  : int.tryParse(json['color'].toString()) ?? Colors.blue.value
            )
          : Colors.blue,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is Timestamp
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.parse(json['createdAt']))
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }
}
