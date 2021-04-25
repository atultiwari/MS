class Option {
  String optionCode;
  String optionText;
  bool optionIsCorrect;

  Option({this.optionCode, this.optionText, this.optionIsCorrect});

  Option.fromJson(Map<String, dynamic> json) {
    optionCode = json['option_code'];
    optionText = json['option_text'];
    optionIsCorrect = json['option_is_correct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option_code'] = this.optionCode;
    data['option_text'] = this.optionText;
    data['option_is_correct'] = this.optionIsCorrect;
    return data;
  }
}
