import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pure_live_chat/authentication/repo/authRepo.dart';
import 'package:pure_live_chat/authentication/view_model/userDataController.dart';
import 'package:pure_live_chat/main_app/chatPanel/view/chatPanel.dart';
import 'package:pure_live_chat/utility/resources/appConst.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  UserDataController userDataController = Get.find();
  @override
  void initState() {
    super.initState();
  }
  bool myDay = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: Get.width / 10,
        leading: Padding(
          padding: EdgeInsets.only(left: Get.width / 20),
          child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.dehaze,
                color: Colors.white,
              ),
              onPressed: () {
                if(scaffoldKey.currentState!.isDrawerOpen){
                  scaffoldKey.currentState!.openEndDrawer();
                }else{
                  scaffoldKey.currentState!.openDrawer();
                }
              }),
        ),
        title: Text('Pure Live'),
        actions: [
          IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: Get.width,
                height: Get.height/3,
                decoration: BoxDecoration(
                  color: AppConst.gradientFirst
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12,),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Container(
                        width: Get.width/4,
                        height: Get.width/4,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppConst.gradientSecond),
                          color: Colors.white,
                        shape: BoxShape.circle,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                userDataController.userData.value!.userPhoto!
                            )
                          )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:14,bottom: 10),
                      child: Text('${userDataController.userData.value!.userName}',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.normal),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:14,bottom: 10),
                      child: Text('${userDataController.userData.value!.email}',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.normal),),
                    ),
                    GestureDetector(
                      onTap: (){},
                      child: Padding(
                        padding: const EdgeInsets.only(left:14,bottom: 10),
                        child: Text('View Profile',style: TextStyle(color: AppConst.gradientSecond,fontSize: 16,fontWeight: FontWeight.normal),),
                      ),
                    ),
                  ],
                )
            ),
            TextButton(
              onPressed: (){

              },
              child: ListTile(
                leading: Icon(Icons.group_outlined,color: AppConst.gradientSecond,),
                title: Text('Friends'),
              ),

            ),
            TextButton(
              onPressed: (){

              },
              child: ListTile(
                leading: Icon(Icons.help_outline,color: AppConst.gradientSecond),
                title: Text('Helpline'),
              ),

            ),
            TextButton(
              onPressed: (){

              },
              child: ListTile(
                title: Text('Settings'),
              ),

            ),
            TextButton(
              onPressed: (){

              },
              child: ListTile(
                title: Text('Terms & Conditions/Privacy'),
              ),

            ),
            TextButton(
              onPressed: (){
                AuthRepo().signOut();
              },
              child: ListTile(
                leading: Icon(Icons.exit_to_app_outlined,color: AppConst.gradientSecond),
                title: Text('Logout'),
              ),

            ),

          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: Get.width / 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Members'),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Get.width / 80,
                    ),
                    child: Container(
                      height: Get.width / 7,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return activeMembers(index);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chats'),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                    return singleMemberPanel(index);
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  activeMembers(int index) {
    return Padding(
      padding: EdgeInsets.only(
        right: Get.width / 25,
      ),
      child: index == 0 ? Container(
          height: Get.width / 7,
          width: Get.width / 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppConst.gradientFirst,
          ),
          child: Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: Get.width / 12,
              ),
              onPressed: () {},
            ),
          )

      ): avatarPicture(myDay: true,index: 1000+index),
    );
  }

  singleMemberPanel(int index) {
    return GestureDetector(
      onTap: ()=> Get.to(()=>ChatPanel()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         avatarPicture(index: 2000+index),
          SizedBox(
            width: 7,
          ),
          Container(
            height: Get.height / 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    width: Get.width / 1.6,
                    child: Text(
                      'Mizutani Shizuku',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Quicksand"),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    width: Get.width / 1.6,
                    child: Text(
                      'Oi oi oi oi oi oi oi ooio io io io ii!',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Quicksand"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 7,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: Get.width / 15,
              width: Get.width / 12,
              decoration:
              BoxDecoration(color: AppConst.gradientFirst,),
              child: Center(
                child: Text(
                  '3',
                  style: TextStyle(
                      color: Colors.white, fontFamily: "Quicksand"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  avatarPicture({bool? myDay,required int index}) {
    return Container(
      height: Get.width / 7,
      width: Get.width / 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppConst.gradientSecond,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              height: Get.width / 7,
              width: Get.width / 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppConst.gradientSecond, width: myDay == null?0:3),
                color: AppConst.gradientFirst,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    // 'https://i.ibb.co/k2wgGXk/received-791042024861031.jpg'
                      'https://fiverr-res.cloudinary.com/images/t_smartwm/t_main1,q_auto,f_auto,q_auto,f_auto/deliveries/101990328/original/2_c/draw-a-cute-anime-manga-girl-face.png'
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 3,
            bottom: 3,
            child: Container(
              height: Get.width / 30,
              width: Get.width / 30,
              decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle),
            ),
          )
        ],
      ),
    );
  }
}
