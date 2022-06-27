class PushNotificationRequest {
  String to;
  NotificationParam notification;
  DataParam data;

  PushNotificationRequest({this.to, this.notification, this.data});

  PushNotificationRequest.fromJson(Map<String, dynamic> json) {
    to = json['to'];
    notification = json['notification'] != null
        ? new NotificationParam.fromJson(json['notification'])
        : null;
    data = json['data'] != null ? new DataParam.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['to'] = this.to;
    if (this.notification != null) {
      data['notification'] = this.notification.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class NotificationParam {
  String body;
  String title;

  NotificationParam({this.body, this.title});

  NotificationParam.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['title'] = this.title;
    return data;
  }
}

class DataParam {
  String body;
  String title;
  String clickAction;

  DataParam({this.body, this.title, this.clickAction});

  DataParam.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    title = json['title'];
    clickAction = json['click-action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['title'] = this.title;
    data['click-action'] = this.clickAction;
    return data;
  }
}
