
import 'package:flutter/material.dart';
import 'package:expense_tracker/expensedatabase.dart';
import 'main.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  SqlDB sqlDB = SqlDB();

  final formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<Map>> readData() async {
    List<Map> response =
    await sqlDB.readData("SELECT * FROM catTable");

    catCount=response.length;
    return response;
  }

  var catCount;

  TextEditingController catText= TextEditingController();
  TextEditingController newCat= TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width; // width of the screen
    //double screenH = MediaQuery.of(context).size.height;
    
    return MaterialApp(
      theme: ThemeData(fontFamily: 'RobotoCondensed-Light'),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: const Text('Expenses Types'),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()));
                //Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            TextButton(onPressed: () {

              if(catCount < 16) {
              showDialog(
                context: context,
                builder: (context)=>  AlertDialog(
                  title: const Text('Add Category'),
                  content: TextFormField(
                    autofocus: true,
                    controller: newCat,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Expense Category is Required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(context).pop();
                    },
                        child: const Text('Cancel')),
                    TextButton(onPressed: () async {
                      int response = await sqlDB.insertData('''
                                     INSERT INTO catTable ('category') VALUES ('${newCat.text}') 
                                     ''');

                      print('Category Update Command Response : $response');

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Category()),
                      );
                      //Navigator.of(context).pop();
                     },
                        child: const Text('Save'))
                  ],
                 ),
               );
              } else {
                final snackBar =
                SnackBar(
                    content: Text('Maximum Number of Categories Has Been Reached!')
                );
                _scaffoldKey.currentState!.showSnackBar(snackBar);
              }
            },
              child: const Align(
              widthFactor: 2,
              child: Text('New',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),)
          ],
        ),
        body: Container(
          color: Colors.white60,
          width: screenW,
          child: ListView(children: [
            FutureBuilder(
                future: readData(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return Card(
                            child: ListTile(
                              title: Text('${snapshot.data!.elementAt(i)['category']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //Text('${snapshot.data!.elementAt(i)['amount']}'),
                                  IconButton(onPressed: () {
                                    setState((){
                                      catText.text= snapshot.data!.elementAt(i)['category'];
                                    });
                                    //editCat();
                                    showDialog(
                                        context: context,
                                        builder: (context)=>  AlertDialog(
                                            title: const Text('Edit Category'),
                                            content: TextFormField(
                                              autofocus: true,
                                                controller: catText,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Expense Category is Required';
                                                  } else {
                                                    return null;
                                                      }
                                                   },
                                                 ),
                                                actions: [
                                                TextButton(onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                    child: const Text('Cancel')),
                                                TextButton(onPressed: () async {
                                                  int response = await sqlDB.updateData('''
                                                              UPDATE catTable SET 
                                                              category= '${catText.text}'
                                                              WHERE id= ${snapshot.data!.elementAt(i)['id']}
                                                              ''');
                                                  print('Category Update Command Respinse : $response');
                                                  Navigator.of(context).pop();
                                                },
                                                    child: const Text('Save'))
                                              ],
                                            ),
                                            );
                                            },
                                      icon: const Icon(Icons.edit,color: Colors.blueAccent,)),
                                  IconButton(onPressed: () async {
                                    int response= await sqlDB.deleteData('''
                                      DELETE FROM catTable WHERE 
                                      id = ${snapshot.data!.elementAt(i)['id']}''');
                                    if (response > 0) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Category()));
                                    }
                                  }, icon: const Icon(Icons.delete,color: Colors.redAccent,))
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  }
                  return const Center(child: Text('No Expenses Available.'));
                })
          ]),
        ),
      ),
    );
  }
}
