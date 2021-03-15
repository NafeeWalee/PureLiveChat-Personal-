class NotificationDataModel{
  String? title;
  String? body;
  String? image;
  NotificationDataModel({
    this.title, this.image, this.body
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) => NotificationDataModel(
    title: json['title'],
    body: json['body'],
    image: json['img'],
  );
}
