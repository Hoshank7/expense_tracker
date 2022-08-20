
import 'package:expense_tracker/editexpense.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/expensedatabase.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);
  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  SqlDB sqlDB = SqlDB();

  Future<List<Map>> readData() async {
    List<Map> response =
        await sqlDB.readData("SELECT * FROM expensesTable WHERE category IS NOT NULL ORDER BY date DESC");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width; // width of the screen
    //double screenH = MediaQuery.of(context).size.height;

    return MaterialApp(
      theme: ThemeData(fontFamily: 'RobotoCondensed-Light'),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: const Text('Edit Expenses'),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Container(
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
                            title: Text('Type: ${snapshot.data!.elementAt(i)['category']}'),
                            subtitle: Text('Date: ${snapshot.data!.elementAt(i)['date']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${snapshot.data!.elementAt(i)['amount']}'),
                                IconButton(onPressed: () {

                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditExpense(
                                    id: snapshot.data!.elementAt(i)['id'],
                                    amount: snapshot.data!.elementAt(i)['amount'],
                                    category: snapshot.data!.elementAt(i)['category'],
                                    date: snapshot.data!.elementAt(i)['date'],

                                     ),
                                   ),
                                  );
                                }, icon: const Icon(Icons.edit,color: Colors.blueGrey,size: 30,)),
                                IconButton(onPressed: () async {
                                  int response= await sqlDB.deleteData('''
                                  DELETE FROM expensesTable WHERE id = ${snapshot.data!.elementAt(i)['id']}''');
                                  if (response > 0) {
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Edit()));
                                  }
                                }, icon: const Icon(Icons.delete,color: Colors.redAccent,size: 30,))
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
