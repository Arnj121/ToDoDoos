import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool add=false,lightmode=true,loaded=false;
  TextEditingController addcont = TextEditingController();
  DatabaseHelper db = DatabaseHelper.instance;
  Random random = Random();String value='';
  List<dynamic> data=[];dynamic temp;List<String> cat=[];
  int dsort=0,csort=0;String type='asc';

  Future initData()async{
    data=[];cat=[];
    List<dynamic> temp = await db.queryAll();
    temp.forEach((e){data.add(jsonDecode(jsonEncode(e)));});
    temp = await db.getcat();
    temp.forEach((e) {
      cat.add(e['category']);
    });
    if (cat.length > 0)
      value = cat[0];
    this.setState(() {});
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
            leading: Icon(
              Icons.toc_sharp,
              color: Colors.blue,
            ),
            title: Text(
              'To-Do',
              style: GoogleFonts.russoOne(
                  fontSize: 25,
                  color: Colors.blue
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
                onPressed: (){this.setState(() {add=!add;});},
              ),
              IconButton(
                icon:Icon(
                  Icons.category_sharp,
                  color: Colors.blue,
                ),
                onPressed: (){Navigator.pushNamed(context,'/categories');},
              ),
              IconButton(
                icon:Icon(
                  Icons.refresh_sharp,
                  color: Colors.blue,
                ),
                onPressed: (){
                  initData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'refreshed',
                        style: GoogleFonts.quicksand(),
                      ),
                      duration: Duration(seconds: 1),
                    )
                  );
                  },
              )
            ],
          ),
          body:Scrollbar(
            child: CustomScrollView(
              slivers: [
                SliverVisibility(
                  visible: add,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                        [
                          SizedBox(height: 20,),
                          Center(
                            child: Container(
                              child: TextField(
                                controller: addcont,
                                decoration:InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal:10 ),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.blue)),
                                  filled: true,
                                  fillColor: lightmode?Colors.grey[300]:Colors.grey[800],
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: lightmode?Colors.grey[300]:Colors.grey[800]))
                                ),
                                autofocus: true,
                                maxLines: 2,
                              ),
                              margin: EdgeInsets.symmetric(vertical: 0,horizontal: 30),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Center(
                            child: Text(
                              'Category',
                              style: GoogleFonts.quicksand(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Center(
                            child: Container(
                              child: Center(
                                child: DropdownButton(
                                  value: value,
                                  items: cat.map<DropdownMenuItem<String>>((String e){
                                    return DropdownMenuItem(
                                      child: TextButton.icon(
                                        icon: Icon(
                                          Icons.category_sharp,
                                          color:Colors.blue,
                                        ),
                                        onPressed: (){},
                                        label: Text(e),
                                      ),
                                      value: e,
                                    );
                                  }).toList(),
                                  style: GoogleFonts.quicksand(
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  elevation: 8,
                                  onChanged: (String v){
                                    this.setState(() {
                                      value=v;
                                    });
                                  },
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  dropdownColor: lightmode?Colors.grey[300]:Colors.grey[800],
                                ),
                              ),
                              height: 50,
                              width: 100,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Center(
                            child: ElevatedButton(
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.russoOne(
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red)
                              ),
                              onPressed: (){
                                this.setState(() {
                                  add=!add;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 10,),
                          Center(
                            child: ElevatedButton(
                              child: Text(
                                'Create',
                                style: GoogleFonts.russoOne(
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                              ),
                              onPressed: ()async{
                                int id = random.nextInt(100000);
                                String text =addcont.text.trim();
                                String date = DateTime.now().toString();
                                if(text.length==0){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'To Do cannot be empty!',
                                        style: GoogleFonts.quicksand(),
                                      ),
                                      duration:Duration(seconds: 1),
                                    ),
                                  );
                                }
                                else{
                                  await db.add(id, text, date, value);
                                  data.add({'id':id,'list':text,'date':date,'done':0,'category':value});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'To Do added',
                                        style: GoogleFonts.quicksand(),
                                      ),
                                      duration:Duration(seconds: 1),
                                    ),
                                  );
                                  addcont.text='';
                                  this.setState(() {
                                    add=!add;
                                  });
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent)
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                        ]
                    ),
                  ),
                ),
                SliverVisibility(
                  visible: data.length==0?false:true,
                  sliver: SliverList(
                    delegate:SliverChildListDelegate(
                      [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child:Text(
                                'Sort by',
                                style: GoogleFonts.quicksand(
                                  color: Colors.blue,
                                  fontSize: 17
                                ),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      type=='asc'?Icons.arrow_upward_sharp:Icons.arrow_downward_sharp
                                    ),
                                    onPressed: ()async{
                                      type=type=='asc'?'desc':'asc';
                                      dynamic res = await db.getSorted(
                                          dsort, csort,type);
                                      dynamic temp = [];
                                      res.forEach((e) {
                                        temp.add(jsonDecode(jsonEncode(e)));
                                      });
                                      this.setState(() {
                                        data = temp;
                                        type=type;
                                      });
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Date',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.blue,
                                        fontSize: 17
                                      ),
                                    ),
                                    onPressed: ()async{
                                      dsort=dsort==1?0:1;
                                      if(csort==0 && dsort==0){
                                        this.initData();
                                      }
                                      else {
                                        dynamic res = await db.getSorted(
                                            dsort, csort,type);
                                        dynamic temp = [];
                                        res.forEach((e) {
                                          temp.add(jsonDecode(jsonEncode(e)));
                                        });
                                        this.setState(() {
                                          data = temp;
                                        });
                                      }
                                    },
                                  ),
                                  // SizedBox(width: 10,),
                                  TextButton(
                                    child: Text(
                                      'Completed',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.blue,
                                          fontSize: 17
                                      ),
                                    ),
                                    onPressed: ()async{
                                      csort = csort==1?0:1;
                                      if(csort==0 && dsort==0){
                                        this.initData();
                                      }
                                      else {
                                        dynamic res = await db.getSorted(
                                            dsort, csort,type);
                                        dynamic temp = [];
                                        res.forEach((e) {
                                          temp.add(jsonDecode(jsonEncode(e)));
                                        });
                                        this.setState(() {
                                          data = temp;
                                        });
                                      }

                                    },
                                  )
                                ],
                              ),
                              margin: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                            )
                          ],
                        ),
                      ]
                    )
                  ),
                ),
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
    dynamic date = DateTime.parse(data[index]['date'].toString());
    date = date.day.toString()+'/'+date.month.toString()+'/'+date.year.toString();
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
          data[index]['category'].length==0?'No category\n$date':'${data[index]['category']}\n$date',
          style: GoogleFonts.quicksand(
              color: Colors.orange
          ),
        ),
        isThreeLine: true,
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
