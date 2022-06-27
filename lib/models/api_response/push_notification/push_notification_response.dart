class PushNotificationResponse {
  int multicastId;
  int success;
  int failure;
  int canonicalIds;
  List<Results> results;

  PushNotificationResponse(
      {this.multicastId,
      this.success,
      this.failure,
      this.canonicalIds,
      this.results});

  PushNotificationResponse.fromJson(Map<String, dynamic> json) {
    multicastId = json['multicast_id'];
    success = json['success'];
    failure = json['failure'];
    canonicalIds = json['canonical_ids'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['multicast_id'] = this.multicastId;
    data['success'] = this.success;
    data['failure'] = this.failure;
    data['canonical_ids'] = this.canonicalIds;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String error;

  Results({this.error});

  Results.fromJson(Map<String, dynamic> json) {
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    return data;
  }
}
