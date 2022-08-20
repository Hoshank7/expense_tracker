// ignore_for_file: prefer_const_constructors
import 'package:expense_tracker/edit.dart';
import 'package:expense_tracker/expensedatabase.dart';
//import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';

class EditExpense extends StatefulWidget {
  final date ;
  final amount;
  final category;
  final id;
  const EditExpense({Key? key, this.date, this.amount, this.category, this.id}) : super(key: key);


  @override
  State<EditExpense> createState() => _EditExpense();
}

class _EditExpense extends State<EditExpense> {
  String type = '';
  int amount = 1;

  final formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> catTypes = [];
  String? selectedCat;

  Future<List> readCat() async {
    List cat= await sqlDB.readData("SELECT category from catTable");

    List<String> catList=[];

    cat.forEach((element) {
      catList.add(element['category']);
    });

    setState((){
      catTypes=catList;
    });

    return cat;
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(item),
  );

  TextEditingController dateController = TextEditingController(
      text:
      '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}'); //Date field controller with initial value

  TextEditingController amountController = TextEditingController();


  SqlDB sqlDB = SqlDB();


  @override
  void initState() {
    dateController.text=widget.date;
    amountController.text=widget.amount.toString();
    selectedCat=widget.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'RobotoCondensed-Light'),
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            TextButton(onPressed: () async {
              if (formkey.currentState!.validate()) {
                int response = await sqlDB.updateData('''
                        UPDATE expensesTable SET 
                        date= '${dateController.text}',
                        category='$selectedCat', 
                        amount='${amountController.text}'
                        WHERE id= ${widget.id}''');
                print('Expense Update Response is: $response ==============================');

                if(response>0) {
                final snackBar =
                SnackBar(content: Text('Expense Saved!'));
                _scaffoldKey.currentState!.showSnackBar(snackBar);

                Future.delayed(Duration(milliseconds: 15), () {
                  //Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Edit()));
                });
              }}
            }
              , child: Align(
                widthFactor: 3,
                child: Text('Save',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            )
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Edit Expense'),
          backgroundColor: Colors.red[900],
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: FutureBuilder(
            future: readCat(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasData) {
            return
             Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: dateController,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2040));

                      //_showDatePicker();
                      if (pickedDate != null) {
                        setState(() {
                          dateController.text =
                          '${pickedDate.year}/${pickedDate.month}/${pickedDate.day}';
                        });
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Expense Date',
                        labelStyle: TextStyle(fontSize: 20.0),
                        icon: Icon(Icons.calendar_today_rounded)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Expense Date is Required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: const [
                      Icon(Icons.list),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        'Expense Type',
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: DropdownButtonFormField(
                      items: catTypes.map(buildMenuItem).toList(),
                      value: selectedCat,
                      onChanged: (String? value) =>
                          setState(() => selectedCat = value),
                      hint: Text('Please select expense type'),
                      icon: Icon(Icons.arrow_drop_down),
                      validator: (value) {
                        if (value == null) {
                          return 'Expense Type is Required!';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Expense Amount',
                      icon: Icon(Icons.currency_exchange),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty
                      //||
                          //!RegExp(r'^[0-9]+$').hasMatch(value)
                      ) {
                        return 'Please Enter Expense Amount!';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 30),
                ],
              ),
            );
            } else {
              return Center(child: Text('Expense Type Was Not Found'));
              }
            }
          ),
        ),
      ),
    );
  }
}
