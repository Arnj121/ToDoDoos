import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/database.dart';
class CatView extends StatefulWidget {
  @override
  _CatViewState createState() => _CatViewState();
}

class _CatViewState extends State<CatView> {

  bool lightmode=true;
  dynamic data =[];
  DatabaseHelper db = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    lightmode = MediaQuery.of(context).platformBrightness == Brightness.light;
    data = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightmode?Colors.white:null,
        appBar: AppBar(
          backgroundColor: lightmode?Colors.white:null,
          elevation: 0,
          titleSpacing: 0,
          leading: BackButton(color: Colors.blue,),
          title: Text(
            'Category View',
            style: GoogleFonts.russoOne(
              color: Colors.blue
            ),
          ),
        ),
        body: Scrollbar(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context,int index){
                      return todoBuilder(index);
                    },
                  childCount: data.length
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Container todoBuilder(int index){
    return Container(
      child: ListTile(
        leading: Checkbox(
          checkColor: Colors.green,
          value: data[index]['done']==1?true:false,
          onChanged: (v)async{
            int d = 1;
            if(data[index]['done']==1)
              d=0;
            await db.mark(data[index]['id'], d);
            data[index]['done']=d;
            this.setState(() {
              data=data;
            });
          },
        ),
        title: Text(
          data[index]['list'],
          style: GoogleFonts.quicksand(
              fontSize: 25,
              color:Colors.orangeAccent
          ),
        ),
        subtitle: Text(
          data[index]['category'].length==0?'No category':data[index]['category'],
          style: GoogleFonts.quicksand(
              color: Colors.orange
          ),
        ),
        contentPadding: EdgeInsets.all(0),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.redAccent,
          ),
          onPressed: ()async{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Remove To-Do?',
                  style: GoogleFonts.quicksand(),
                ),
                action: SnackBarAction(
                  onPressed: ()async{
                    await db.deleteList(data[index]['id']);
                    this.setState(() {
                      data.removeAt(index);
                    });
                  },
                  label: 'remove',
                ),
                duration: Duration(seconds: 5),
              ),
            );
          },
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: lightmode?Colors.grey[300]:Colors.grey[800]
      ),
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      padding: EdgeInsets.all(5),
    );
  }
}
