import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pure_live_chat/main_app/chatPanel/view/chatPanel.dart';
import 'package:pure_live_chat/utility/resources/appConst.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  bool myDay = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
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
                _drawerKey.currentState!.openDrawer();
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
      drawer: Drawer(),
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
            color: AppConst.themePurple,
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
              BoxDecoration(color: AppConst.themePurple),
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
        color: AppConst.themePurple,
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
                border: Border.all(color: Colors.black, width: myDay == null?0:3),
                color: AppConst.themePurple,
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
