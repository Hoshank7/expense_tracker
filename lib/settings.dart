import 'package:expense_tracker/expensedatabase.dart';
import 'package:expense_tracker/main.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/categories.dart';

class Settings extends StatefulWidget {
  final target;
  final currency;
  const Settings({Key? key, this.target, this.currency}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final currency = ['AED', 'USD', 'EUR', 'SAR', 'SYP', 'EGP', 'CNY'];

  String? selectedCurrency;

  TextEditingController targetController = TextEditingController();

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      );

  SqlDB sqlDB = SqlDB();

  @override
  void initState() {
    targetController.text = widget.target;
    selectedCurrency = widget.currency;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'RobotoCondensed-Light'),
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              int response = await sqlDB.updateData('''
                        UPDATE settingsTable SET 
                        currency= '$selectedCurrency',
                        target= '${targetController.text}' 
                        WHERE id= 1
                        ''');

              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MyApp()));

              print('Settings Update Response is: $response');
              print('Settings Updated ====================');
            },
          ),
          title: const Text('Settings'),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: const [
                    Icon(Icons.attach_money_outlined,size: 30,),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      'Currency Type',
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: DropdownButtonFormField(
                    items: currency.map(buildMenuItem).toList(),
                    value: selectedCurrency,
                    onChanged: (String? value) => setState(() {
                      selectedCurrency = value;
                      print('Currency Value is: $selectedCurrency');
                    }),
                    hint: const Text('Please select currency type'),
                    icon: const Icon(Icons.arrow_drop_down),
                    validator: (value) {
                      if (value == null) {
                        return 'Currency Type is Required!';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                TextFormField(
                  controller: targetController,
                  decoration: const InputDecoration(
                    label: Text('Target Monthly Expenses'),
                    icon: Icon(Icons.bar_chart,size: 30,),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter target monthly expenses!';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 11,
                ),
                Row(
                  children: [
                    const Icon(Icons.edit_note_outlined,size: 35,),
                    TextButton(onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Category()));
                    },
                      child: const Text('Edit Expenses Types',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 200,
                ),
                const Center(
                  child: Text('HK Development (C)',
                    style: TextStyle(
                      color: Color.fromRGBO(117, 115, 114, 1)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
