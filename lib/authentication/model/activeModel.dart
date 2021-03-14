
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckInModel{
  Timestamp? lastCheckIn;


  CheckInModel({
    this.lastCheckIn
  });

  Map<String, dynamic> toJson(){
    var data = {

      "lastCheckIn": lastCheckIn??'',


    };
    return data;
  }

  CheckInModel.fromJson(Map<String, dynamic> json){

    lastCheckIn = json['lastCheckIn'];
  }


}