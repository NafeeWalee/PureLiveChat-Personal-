class GroupModel{
  String? groupName;
  List<String>? members;
  String? theme;
  String? groupCode;

  GroupModel({
    this.groupName,
    this.theme,
    this.members,
    this.groupCode,
  });

  Map<String, dynamic> toJson(){
    var data = {
      "groupName" : groupName??'',
      "theme": theme??'',
      "groupCode": groupCode??'',
      "members": members??[],
    };
    return data;
  }

  GroupModel.fromJson(Map<String, dynamic> json){
    groupName = json['groupName'];
    theme = json['theme'];
    groupCode = json['groupCode'];

    if(json['members']!=null){
      members = <String>[];
      json['members'].forEach((v){
        members?.add(v);
      });
    }
  }
}