import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/database.dart';
import 'package:todo/database.dart';
class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  List<String> cat=[];
  bool lightmode=true;
  DatabaseHelper db = DatabaseHelper.instance;
  TextEditingController catcon = TextEditingController();
  Random random = Random();

  Future initData()async{
    dynamic temp = await db.getcat();
    temp.forEach((e){cat.add(jsonDecode(jsonEncode(e['category'])));});
    this.setState((){});
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    lightmode = MediaQuery.of(context).platformBrightness == Brightness.light;
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightmode?Colors.white:null,
        appBar: AppBar(
          backgroundColor: lightmode?Colors.white:null,
          titleSpacing: 0,
          elevation: 0,
          title: Text(
            'Categories',
            style: GoogleFonts.russoOne(
                fontSize: 25,
                color: Colors.blue
            ),
          ),
          leading: BackButton(color: Colors.blue,),
        ),
        body: Scrollbar(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(height: 10,),
                    Center(
                      child: Container(
                        child: TextField(
                          controller: catcon,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal:10 ),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.blue)),
                              filled: true,
                              fillColor: lightmode?Colors.grey[300]:Colors.grey[800],
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: lightmode?Colors.grey[300]:Colors.grey[800]))
                          ),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 0,horizontal: 30),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: ElevatedButton.icon(
                        label: Text(
                          'Add',
                          style: GoogleFonts.russoOne(
                            color: Colors.white,
                            fontSize: 20
                          ),
                        ),
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: ()async{
                          String catinput = catcon.text.trim();
                          if(catinput.length==0){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Enter a name!',
                                  style: GoogleFonts.quicksand(),
                                ),
                                duration: Duration(seconds: 1),
                              )
                            );
                          }
                          else{
                            dynamic temp = await db.getcat();
                            for (int i=0;i<temp.length;i++){
                              if(temp[i]['category']==catinput){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Category already exist',
                                        style: GoogleFonts.quicksand(),
                                      ),
                                      duration: Duration(seconds: 1),
                                    )
                                );
                                return;
                              }
                            }
                            int id = random.nextInt(10000);
                            await db.createCat(id, catinput);
                            cat.add(catinput);
                            this.setState(() {
                              cat=cat;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Category added',
                                    style: GoogleFonts.quicksand(),
                                  ),
                                  duration: Duration(seconds: 1),
                                )
                            );
                            catcon.text='';
                          }
                        },
                      ),
                    )
                  ]
                ),
              ),
              SliverList(
                delegate:SliverChildBuilderDelegate(
                  (BuildContext context, int index){
                    return catBuilder(index);
                  },
                  childCount: cat.length
                )
              )
            ],
          ),
        ),
      ),
    );
  }
  Container catBuilder(int index){
    return Container(
      child: ListTile(
        onTap: ()async{
          dynamic temp  = await db.getListCat(cat[index]);
          Navigator.pushNamed(context, '/catview',arguments: temp);
          },
        dense: true,
        title: Text(
          cat[index],
          style: GoogleFonts.quicksand(
            fontSize: 25,
            color: Colors.purple[200]
          ),
        ),
        leading: Icon(
          Icons.category_sharp,
          color: Colors.green,
          size: 25,
        ),
        subtitle: Text(
          'Click to view',
          style: GoogleFonts.russoOne(
            color: Colors.purple[300]
          ),
        ),
        contentPadding: EdgeInsets.all(0),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: (){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Remove Category?',
                  style: GoogleFonts.quicksand(),
                ),
                duration: Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'remove',
                  onPressed: ()async{
                    await db.deleteCat(cat[index]);
                    SnackBar(
                      content: Text(
                        'Removed category',
                        style: GoogleFonts.quicksand(),
                      ),
                      duration: Duration(seconds: 5),
                    );
                    this.setState(() {
                      cat.removeAt(index);
                    });
                  },
                ),
              )
            );
          },
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      padding:EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: lightmode?Colors.grey[300]:Colors.grey[800]
      ),
    );
  }
}
