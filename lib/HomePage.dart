import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  final User? user;
  HomePage(this.user);

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Instagram에 오신 것을 환영합니다',
                  style: TextStyle(fontSize: 24),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                Text('사진과 동영상을 보려면 팔로우 하세요.'),
                SizedBox(
                  width: 260,
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        SizedBox(
                            width: 80,
                            height: 80,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user?.photoURL==null ? "https://w.namu.la/s/f63b5deafb5fbc936d89fedc14735f14ede8471b6ee39ae56341daeea9f3e322dca5b7ae2294d3b2892bfa587059c5898cdc592880e234ba9c7e39f70a53d21c1f60fbb5f19d9e4ab23f0b2d28d225504afe0e1ea9846a7c9905370ed17a1ba4a8c530bf674e37f3d8b4b715562ea27e"
                              : user!.photoURL!),
                            )),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Text(user?.email==null ? "Guest" : user!.email!),
                        Text(user?.displayName==null ? "No email data" : user!.displayName!),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: Image.network('https://t1.daumcdn.net/cfile/tistory/994BEF355CD0313D05', fit: BoxFit.cover,),
                            ),
                            Padding(
                              padding: EdgeInsets.all(1),
                            ),
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: Image.network('https://t1.daumcdn.net/cfile/tistory/994BEF355CD0313D05', fit: BoxFit.cover,),
                            ),
                            Padding(
                              padding: EdgeInsets.all(1),
                            ),
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: Image.network('https://t1.daumcdn.net/cfile/tistory/994BEF355CD0313D05', fit: BoxFit.cover,),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(4),
                        ),
                        Text('Facebook 친구'),
                        Padding(
                          padding: EdgeInsets.all(4),
                        ),
                        ElevatedButton(
                          child: Text('팔로우'),
                          style: ButtonStyle(
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(color: Colors.white)),
                              backgroundColor:
                              MaterialStateProperty.all(Colors.blueAccent)),
                          onPressed: () {},
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
