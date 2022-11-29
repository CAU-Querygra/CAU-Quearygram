import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  final User? user;

  AccountPage(this.user);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          '𝔦𝔫𝔰𝔱𝔞𝔤𝔯𝔞𝔪 𝔠𝔩𝔬𝔫',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
            ),
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              signOutWithGoogle();
            },
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.user?.photoURL ==
                              null
                          ? "https://w.namu.la/s/f63b5deafb5fbc936d89fedc14735f14ede8471b6ee39ae56341daeea9f3e322dca5b7ae2294d3b2892bfa587059c5898cdc592880e234ba9c7e39f70a53d21c1f60fbb5f19d9e4ab23f0b2d28d225504afe0e1ea9846a7c9905370ed17a1ba4a8c530bf674e37f3d8b4b715562ea27e"
                          : widget.user!.photoURL!),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.bottomRight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 27,
                          height: 27,
                          child: ClipOval(
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: FloatingActionButton(
                            backgroundColor: Colors.blue,
                            onPressed: () {},
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8),
              ),
              Text(
                widget.user?.displayName == null
                    ? "No email data"
                    : widget.user!.displayName!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Text(
            '0\n게시물',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '0\n팔로워',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '0\n팔로잉',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Future<Null> signOutWithGoogle() async {
    try {
      // Sign out with firebase
      await FirebaseAuth.instance.signOut();
      //await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
    } catch (e) {
      print('failed : ${e.toString()}');
    }
  }
}
