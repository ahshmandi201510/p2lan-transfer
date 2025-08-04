import 'package:isar/isar.dart';
import 'dart:convert';

part 'unified_history_data.g.dart';

@collection
class UnifiedHistoryData {
  Id id = Isar.autoIncrement;

  String? title; // The 'question' or expression
  late String value; // The 'answer' or result
  late DateTime timestamp;

  @Index()
  late String
      type; // 'password', 'number', 'date', 'color', 'bmi', 'financial_loan', 'financial_investment', 'financial_compound', etc.

  // Additional fields for calculator history
  String? subType; // For financial: 'loan', 'investment', 'compound'
  String? _inputsData; // JSON string for inputs
  String? _resultsData; // JSON string for results
  String? displayTitle; // Formatted display title

  @ignore
  Map<String, dynamic> get inputsData {
    if (_inputsData == null) return {};
    return json.decode(_inputsData!) as Map<String, dynamic>;
  }

  set inputsData(Map<String, dynamic> value) {
    _inputsData = json.encode(value);
  }

  @ignore
  Map<String, dynamic> get resultsData {
    if (_resultsData == null) return {};
    return json.decode(_resultsData!) as Map<String, dynamic>;
  }

  set resultsData(Map<String, dynamic> value) {
    _resultsData = json.encode(value);
  }

  UnifiedHistoryData({
    this.id = Isar.autoIncrement,
    this.title,
    required this.value,
    required this.timestamp,
    required this.type,
    this.subType,
    this.displayTitle,
    Map<String, dynamic>? inputsData,
    Map<String, dynamic>? resultsData,
  }) {
    if (inputsData != null) this.inputsData = inputsData;
    if (resultsData != null) this.resultsData = resultsData;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'subType': subType,
      'displayTitle': displayTitle,
      'inputsData': inputsData,
      'resultsData': resultsData,
    };
  }

  factory UnifiedHistoryData.fromJson(Map<String, dynamic> json) {
    return UnifiedHistoryData(
      title: json['title'],
      value: json['value'],
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
      subType: json['subType'],
      displayTitle: json['displayTitle'],
      inputsData: json['inputsData'] != null
          ? Map<String, dynamic>.from(json['inputsData'])
          : null,
      resultsData: json['resultsData'] != null
          ? Map<String, dynamic>.from(json['resultsData'])
          : null,
    );
  }

  // Factory constructor for BMI history
  factory UnifiedHistoryData.bmi({
    required String title,
    required String value,
    required DateTime timestamp,
    required Map<String, dynamic> inputsData,
    required Map<String, dynamic> resultsData,
  }) {
    return UnifiedHistoryData(
      title: title,
      value: value,
      timestamp: timestamp,
      type: 'bmi',
      displayTitle: title,
      inputsData: inputsData,
      resultsData: resultsData,
    );
  }

  // Factory constructor for Financial calculator history
  factory UnifiedHistoryData.financial({
    required String title,
    required String value,
    required DateTime timestamp,
    required String subType, // 'loan', 'investment', 'compound'
    required Map<String, dynamic> inputsData,
    required Map<String, dynamic> resultsData,
    required String displayTitle,
  }) {
    return UnifiedHistoryData(
      title: title,
      value: value,
      timestamp: timestamp,
      type: 'financial',
      subType: subType,
      displayTitle: displayTitle,
      inputsData: inputsData,
      resultsData: resultsData,
    );
  }
}
