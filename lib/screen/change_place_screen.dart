import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last/screen/account_settings_screen.dart';
import 'package:last/mypage/setting.dart';

class ChangePlacePage extends StatefulWidget {
  @override
  _ChangePlacePageState createState() => _ChangePlacePageState();
}

class _ChangePlacePageState extends State<ChangePlacePage> {

  String currentEmail = FirebaseAuth.instance.currentUser.email;
  final _favoritePlace = ['A08사범대학','B01노천강당','B02상경관','B03인문관','C04인문계식당','D생활관','E02천마아트센터','E21IT관','E29기계관','F01약대본관','F24과학도서관','G01생활과학대학본관'];
  var _selectPlace;

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자주가는 건물 변경',style: TextStyle(fontFamily: mySetting.font),),
      ),
      body: Column(
        children: <Widget> [
          Row(
                      children: <Widget>[
                        Text('자주가는 건물',style: TextStyle(fontSize: 15,fontFamily: mySetting.font),),
                        SizedBox(width: 30,),
                        DropdownButton(
                          value: _selectPlace,
                          items: _favoritePlace.map(
                            (value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value,style: TextStyle(fontFamily: mySetting.font),),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectPlace = value;
                            });
                          },
                        ),
                      ],
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text('Update',style: TextStyle(fontFamily: mySetting.font),),
              onPressed: () {          
                FirebaseFirestore.instance
                  .collection('User')
                  .doc(currentEmail)
                  .update({'FavoritePlace' :  _selectPlace }); 
                Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
                    return AccountSetting();
                    }));     
              },
            ),
          ],
        ),
    );
  }
}



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold (
//       appBar: AppBar (
//         title: Text('계정정보'),
//       ),  
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//           .collection("User")
//           .where("Email", isEqualTo: currentEmail)
//           .snapshots(),
//         builder: (context, snapshot) {
//         if (!snapshot.hasData) return CircularProgressIndicator();

//           return _buildList(context, snapshot.data.docs);
//         },
//       ),
//     );
//   }

//  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//    return ListView(
//      padding: const EdgeInsets.only(top: 20.0),
//      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//    );
//  }

//  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  
//   final _favoritePlace = ['A08사범대학','B01노천강당','B02상경관','B03인문관','C04인문계식당','D생활관','E02천마아트센터','E21IT관','E29기계관','F01약대본관','F24과학도서관','G01생활과학대학본관'];
//   var _selectPlace = data['FavoritePlace'];
//   //var _selectPlace;

//   return Form(
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Column(
//         children: <Widget> [
//           Row(
//                       children: <Widget>[
//                         Text('자주가는 건물',style: TextStyle(fontSize: 15),),
//                         SizedBox(width: 30,),
//                         DropdownButton(
//                           value: _selectPlace,
//                           items: _favoritePlace.map(
//                             (value) {
//                               return DropdownMenuItem(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             },
//                           ).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               _selectPlace = value;
//                             });
//                           },
//                         ),
//                       ],
//             ),
//             RaisedButton(
//               color: Colors.blue,
//               child: Text('Update'),
//               onPressed: () {          
//                 FirebaseFirestore.instance
//                   .collection('User')
//                   .doc(currentEmail)
//                   .update({'FavoritePlace' :  _selectPlace }); 

//                 Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
//                     return AccountSetting();
//                     }));     
//               },
//             ),
//           ],
//         ),
//     ),
//     );
//   }
// }