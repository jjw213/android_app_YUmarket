/*
* 최초 작성자 : 이상수
* 작성일 : 2020.11.14
* 변경일 : 2020.11.21
* 기능 설명 : 검색한 자주 묻는 질문들의 내용을 확인하기 위한 페이지
* */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last/mypage/setting.dart';

class FaqInfo extends StatelessWidget {
  DocumentSnapshot doc;
  FaqInfo({@required this.doc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('자주 묻는 질문',style: TextStyle(fontFamily: mySetting.font),),
        ),
        body: ListTile(
          title: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '질문',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black,fontFamily: mySetting.font
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 10.0,
                  child: Container(
                    alignment: Alignment.center,
                    width: 380,
                    height: 200,
                    child: Text(
                      doc['Title'],
                      style: TextStyle(
                        fontSize: 18,fontFamily: mySetting.font
                      ),
                    ),
                  ),
                ),
                Text(
                  '답변',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black,fontFamily: mySetting.font
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 10.0,
                  child: Container(
                    alignment: Alignment.center,
                    width: 380,
                    height: 250,
                    child: Text(
                      doc['Contents'],
                      style: TextStyle(
                        fontSize: 15,fontFamily: mySetting.font
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
