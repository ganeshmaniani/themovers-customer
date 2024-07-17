class PremiumAutoCompletePredictions {
  List<PredictionsList>? predictionsList;
  String? status;

  PremiumAutoCompletePredictions({this.predictionsList, this.status});

  PremiumAutoCompletePredictions.fromJson(Map<String, dynamic> json) {
    if (json['predictions'] != null) {
      predictionsList = <PredictionsList>[];
      json['predictions'].forEach((v) {
        predictionsList!.add(PredictionsList.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (predictionsList != null) {
      data['predictions'] = predictionsList!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class PredictionsList {
  String? description;
  List<CustomSubstrings>? matchedSubstrings;
  String? placeId;
  String? reference;
  CustomStructuredFormatting? structuredFormatting;
  List<CustomTerms>? terms;
  List<String>? types;

  PredictionsList(
      {this.description,
      this.matchedSubstrings,
      this.placeId,
      this.reference,
      this.structuredFormatting,
      this.terms,
      this.types});

  PredictionsList.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    if (json['matched_substrings'] != null) {
      matchedSubstrings = <CustomSubstrings>[];
      json['matched_substrings'].forEach((v) {
        matchedSubstrings!.add(CustomSubstrings.fromJson(v));
      });
    }
    placeId = json['place_id'];
    reference = json['reference'];
    structuredFormatting = json['structured_formatting'] != null
        ? CustomStructuredFormatting.fromJson(json['structured_formatting'])
        : null;
    if (json['terms'] != null) {
      terms = <CustomTerms>[];
      json['terms'].forEach((v) {
        terms!.add(CustomTerms.fromJson(v));
      });
    }
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    if (matchedSubstrings != null) {
      data['matched_substrings'] =
          matchedSubstrings!.map((v) => v.toJson()).toList();
    }
    data['place_id'] = placeId;
    data['reference'] = reference;
    if (structuredFormatting != null) {
      data['structured_formatting'] = structuredFormatting!.toJson();
    }
    if (terms != null) {
      data['terms'] = terms!.map((v) => v.toJson()).toList();
    }
    data['types'] = types;
    return data;
  }
}

class CustomStructuredFormatting {
  String? mainText;
  List<CustomSubstrings>? mainTextMatchedSubstrings;
  String? secondaryText;

  CustomStructuredFormatting(
      {this.mainText, this.mainTextMatchedSubstrings, this.secondaryText});

  CustomStructuredFormatting.fromJson(Map<String, dynamic> json) {
    mainText = json['main_text'];
    if (json['main_text_matched_substrings'] != null) {
      mainTextMatchedSubstrings = <CustomSubstrings>[];
      json['main_text_matched_substrings'].forEach((v) {
        mainTextMatchedSubstrings!.add(CustomSubstrings.fromJson(v));
      });
    }
    secondaryText = json['secondary_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['main_text'] = mainText;
    if (mainTextMatchedSubstrings != null) {
      data['main_text_matched_substrings'] =
          mainTextMatchedSubstrings!.map((v) => v.toJson()).toList();
    }
    data['secondary_text'] = secondaryText;
    return data;
  }
}

class CustomTerms {
  int? offset;
  String? value;

  CustomTerms({this.offset, this.value});

  CustomTerms.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offset'] = offset;
    data['value'] = value;
    return data;
  }
}

class CustomSubstrings {
  int? length;
  int? offset;

  CustomSubstrings({this.length, this.offset});

  CustomSubstrings.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = length;
    data['offset'] = offset;
    return data;
  }
}