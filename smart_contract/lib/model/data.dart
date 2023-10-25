class Data {
  String? code;
  double? probability;
  String? result;
  int? startIndex;
  int? endIndex;
  Data();

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'] as String;
    probability = json['probability']?.toDouble();
    result = json['result'] as String;
    startIndex = json['startIndex'] as int;
    endIndex = json['endIndex'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['probability'] = probability;
    data['result'] = result;
    data['startIndex'] = startIndex;
    data['endIndex'] = endIndex;
    return data;
  }
}
