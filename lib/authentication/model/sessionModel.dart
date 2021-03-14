class UserSessionModel{
  String? email;
  String? userType;
  String? userLoginType;
  String? userGroupID;


  UserSessionModel({
    this.email,
    this.userType,
    this.userLoginType,
    this.userGroupID
  });

  Map<String, dynamic> toJson(){
    var data = {
      "email": email??'',
      "userType": userType??'',
      "userLoginType": userLoginType??'',
      "userGroupID": userGroupID??'',
    };
    return data;
  }

  UserSessionModel.fromJson(Map<String, dynamic> json){
    email = json['email'];
    userType = json['userType'];
    userLoginType = json['userLoginType'];
    userGroupID = json['userGroupID'];

  }


}