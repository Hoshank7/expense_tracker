// ignore_for_file: prefer_const_constructors
//import 'dart:ffi';
import 'dart:ffi';

import 'package:expense_tracker/edit.dart';
import 'package:expense_tracker/expensedatabase.dart';
import 'package:expense_tracker/input.dart';
import 'package:expense_tracker/settings.dart';
import 'package:expense_tracker/trends.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pie_chart/pie_chart.dart' as pie;

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  SqlDB sqlDB = SqlDB();

  String firstDate = '${DateTime.now().year}/${DateTime.now().month}/1';

  String startOfYear= '${DateTime.now().year}/1/1';

  String endOfYear= '${DateTime.now().year + 1}/1/1';

  String finalDate =
      '';// final date used in readData() sql, date of the first day of next month



// Functions:

  // below function is used to get the date of the first day in next month
  getCurrentDate() {
    final now = DateTime.now();

    DateTime firstDay = DateTime(now.year, now.month, 1);

    var date = DateTime(now.year, now.month + 1, 1).toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.year}/${dateParse.month}/${dateParse.day}";

    setState(() {
      finalDate = formattedDate.toString();
      startDate = firstDay;
    });
  }

  DateTime today = DateTime.now();

  late DateTime startDate;

  late int duration;

  calcDays() {
    int numberDays = today.difference(startDate).inDays;

    setState(() {
      duration = numberDays;
    });
  }

  Map<String, double> catMap={'Types': 0};

  getCategories() async {

    List expenseCat= await sqlDB.readData(''' 
    SELECT category,SUM(amount) FROM expensesTable WHERE date BETWEEN '$firstDate' AND '$finalDate' GROUP BY category ''');

    var categoriesList= expenseCat.toList();

    int i=1;
    while(i<categoriesList.length) {
        catMap[categoriesList.elementAt(i)['category']] = categoriesList.elementAt(i)['SUM(amount)'];
        i++;
    }
    print('Cat Map : $catMap');
  }

  double todayExpensesValue= 0;

  addExpensesList() async {
    List todayExpenses= await sqlDB.readData('''
                        SELECT SUM(amount) 
                        FROM expensesTable 
                        WHERE date = "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}" 
                        ''');

    var todayExpensesList= todayExpenses.toList();

    todayExpensesList.forEach((element) {
      if(element['SUM(amount)']!= null) {
        todayExpensesValue=element['SUM(amount)'];
      }
    }
    );
  }

  String? targetExpense ;
  String? selectedCurrency='';
  double availableFunds= 0 ;
  double allowedSpendingToday= 0;

  // Below getSettings function is used to find allowed spending too
  getSettings() async {
    List settingsData= await sqlDB.readData('SELECT * FROM settingsTable');
    List totalExpenses = await sqlDB.readData(
        "SELECT SUM(amount) FROM expensesTable WHERE date BETWEEN '$firstDate' AND '$finalDate'");

    targetExpense=settingsData.elementAt(0)['target'].toString();
    setState((){
    selectedCurrency=settingsData.elementAt(0)['currency'];
    });

    availableFunds=(settingsData.elementAt(0)['target']/30) * duration;
    double x= availableFunds-totalExpenses.elementAt(0)['SUM(amount)'];

    if(x>0){
      setState(() {
        allowedSpendingToday=x;
      });
    }

    print('Settings Were Obtained ========= ');
  }

  Widget bottomMonthTitles(double value, TitleMeta meta) {
    List<String> titles = ["", "Jan", "Feb", "Mar", "Apr", "May", "June","Jul","Aug","Sep","Oct","Nov","Dec"];
    Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        //color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  Widget bottomDailyTitles(double value, TitleMeta meta) {
    List<String> titles =
    ["", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16","17","18","19","20",
    "21","22","23","24","25","26","27","28","29","30","31"];
    Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        //color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 12, //margin top
      child: text,
    );
  }

  Future<List<Map>> readData() async {
    List<Map> response = await sqlDB.readData(
        "SELECT SUM(amount) FROM expensesTable WHERE date BETWEEN '$firstDate' AND '$finalDate'");

      if(response.isEmpty) {
        int insert = sqlDB.insertData('''
                        INSERT INTO expensesTable ('date','amount') 
                        VALUES ('${DateTime.now().year}/${DateTime.now().month}/1', '0')''');
        print(insert);
    }
    return response;
  }

  @override
  void initState() {
    super.initState();
    //Future.delayed(Duration.zero, () => addExpensesList());
    WidgetsBinding.instance.addPostFrameCallback((_) => getSettings());
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width; // width of the screen
    double screenH = MediaQuery.of(context).size.height; // height of the screen
    getCurrentDate();
    calcDays();
    getCategories();
    //getSettings();
    addExpensesList();
    int navBarIndex= 0;

    return MaterialApp(
      theme: ThemeData(fontFamily: 'RobotoCondensed-Light'),
      home: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Input()),
              );
            },
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.add),
          ),
          backgroundColor: Colors.blueGrey[50],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: navBarIndex,
            backgroundColor: Colors.red[900],
            unselectedItemColor: Colors.white54,
            selectedItemColor: Colors.white,
            onTap: (index) {
              setState((){
                navBarIndex=index;
              });
              if(navBarIndex == 0){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              }
              if(navBarIndex == 1){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Trends()),
                );
              }
              if(navBarIndex == 2){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Edit()),
                );
              }
              if(navBarIndex == 3){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Settings(
                  target: targetExpense,
                  currency: selectedCurrency,
                ),
                ),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  //backgroundColor: Colors.red
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: 'Trends'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.edit),
                  label: 'Edit'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings')
            ],
          ),
          appBar: AppBar(
            // actions: [IconButton(onPressed: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const Edit()),
            //   );
            // },
            //     icon: Icon(Icons.edit_note_outlined,
            //     size: 40,)
            // )
            // ],
            // leading: IconButton(
            //     onPressed: () {
            //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => Settings(
            //         target: targetExpense,
            //         currency: selectedCurrency,
            //       ),
            //       ),
            //       );
            //     },
            //     icon: Icon(Icons.settings,
            //     size: 38,)),
            title:  Center(child: Text('My Expense Tracker',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white ),)),
            backgroundColor: Colors.red[900],
          ),
          body: Container(
            child: ListView(
              children: [
                FutureBuilder(
                    future: readData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map>> snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            SizedBox(
                              height: screenH * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.black26
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 5,
                                    color: Colors.white,
                                    child: SizedBox(
                                      width: screenW * 0.47,
                                      height: screenH * 0.1,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: screenH * 0.01,
                                          ),
                                          Text('Current Month Expenses',
                                              style: TextStyle(fontSize: 14,color: Colors.blueGrey[700],fontWeight: FontWeight.bold)
                                          ),
                                          SizedBox(
                                            height: screenH * 0.01,
                                          ),
                                          Text(
                                              '${(snapshot.data![0]['SUM(amount)'])~/1} $selectedCurrency',
                                              style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                    )
                                ),
                                //Space Between Current Month Expenses and Today Expenses
                                SizedBox(
                                  width: screenW * 0.001,
                                ),
                                Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black26
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 5,
                                    color: Colors.white,
                                    child: SizedBox(
                                      width: screenW * 0.47,
                                      height: screenH * 0.1,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: screenH * 0.01,
                                          ),
                                          Text('Total Expenses Today',
                                              style: TextStyle(fontSize: 14,color: Colors.blueGrey[700],fontWeight: FontWeight.bold)
                                          ),
                                          SizedBox(
                                            height: screenH * 0.01,
                                          ),
                                          Text(
                                              '${(todayExpensesValue ~/1).toString()} $selectedCurrency',
                                              style: TextStyle(fontSize: 20)
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black26
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    //shadowColor: Colors.white70,
                                    elevation: 5,
                                    color: Colors.white,
                                    child: SizedBox(
                                      width: screenW * 0.47,
                                      height: screenH * 0.1,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: screenH * 0.01,
                                          ),
                                          Text('Current Month Average',
                                            style: TextStyle(fontSize: 14,color: Colors.blueGrey[700],fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: screenH * 0.01,
                                          ),
                                          Text(
                                              '${snapshot.data![0]['SUM(amount)']~/duration} $selectedCurrency',
                                              style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                    ),
                                ),
                                SizedBox(
                                  width: screenW * 0.001,
                                ),
                                Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black26
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    //shadowColor: Colors.white70,
                                    elevation: 5,
                                    color: Colors.white,
                                    child: SizedBox(
                                      width: screenW * 0.47,
                                      height: screenH * 0.1,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: screenH * 0.01,
                                          ),
                                          Text("Today's Allowance",
                                              style: TextStyle(fontSize: 14,color: Colors.blueGrey[700],fontWeight: FontWeight.bold)
                                          ),
                                          SizedBox(
                                            height: screenH * 0.01,
                                          ),
                                          Text(
                                              '${allowedSpendingToday~/1} $selectedCurrency',
                                              style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: screenH * 0.06,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.black26
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                //shadowColor: Colors.white70,
                                elevation: 5,
                                color: Colors.white,
                              // Container(
                              //   width: screenW * 0.98 ,
                              //   height: screenH * 0.4,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(10),
                              //     border: Border.all(
                              //       color: Colors.black12,
                              //       width: 2,
                              //     ),
                              //     color: Colors.white,
                              //   ),

                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: screenH * 0.01,
                                    ),
                                    Container(decoration: BoxDecoration(
                                      //color: Colors.white
                                    ),
                                      height: screenH * 0.05,
                                      width: screenW,
                                      child: Center(
                                        child: Text('Expenses Types',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: Colors.blueGrey[700]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: pie.PieChart(
                                        dataMap: catMap,
                                        colorList:  [
                                          Colors.white,
                                          Colors.blue.shade300,
                                          Colors.blueGrey,
                                          Colors.greenAccent,
                                          Colors.red.shade200,
                                          Colors.grey,
                                          Colors.purple,
                                          Colors.deepPurple,
                                          Colors.orangeAccent,
                                          Colors.yellow.shade200,
                                          Colors.black12,
                                          Colors.teal,
                                          Colors.cyan,
                                          Colors.orange,
                                          Colors.lime.shade800],
                                        chartRadius: screenW/1.7,
                                        chartType: pie.ChartType.ring,
                                        ringStrokeWidth: 25,
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenH * 0.03,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenH * 0.02,
                            ),
                            // Container(decoration: BoxDecoration(
                            //   //color: Colors.white
                            // ),
                            //   height: screenH * 0.05,
                            //   width: screenW,
                            //   child: Center(
                            //     child: Text('This Month Trend',
                            //       style: TextStyle(fontWeight: FontWeight.bold,
                            //       fontSize: 25),
                            //   ),
                            // ),
                            // ),
                            // SingleChildScrollView(
                            //   scrollDirection: Axis.horizontal,
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       border: Border.all(
                            //         color: Colors.black12,
                            //         width: 2,
                            //       ),
                            //       borderRadius: BorderRadius.circular(10),
                            //       color: Colors.white,
                            //     ),
                            //     width: screenW * 1.25 ,
                            //     height: screenH * 0.5,
                            //     margin: EdgeInsets.only(left: 3,top: 1) ,
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(11.0),
                            //       child: BarChart(BarChartData(
                            //           borderData: FlBorderData(
                            //               border: const Border(
                            //                   bottom: BorderSide(),
                            //                   left: BorderSide()),
                            //           ),
                            //           alignment: BarChartAlignment.center,
                            //           groupsSpace:5,
                            //           gridData: FlGridData(
                            //             show: true,
                            //             drawVerticalLine: false,
                            //             drawHorizontalLine: true,
                            //             // horizontalInterval: 10,
                            //             getDrawingHorizontalLine: (value) {
                            //               return FlLine(
                            //                 color: Colors.grey,
                            //                 strokeWidth: 1,
                            //               );
                            //             },
                            //           ),
                            //           titlesData: FlTitlesData(
                            //             show: true,
                            //             rightTitles: AxisTitles(
                            //               sideTitles:
                            //                   SideTitles(showTitles: false),
                            //             ),
                            //             topTitles: AxisTitles(
                            //               sideTitles:
                            //                   SideTitles(showTitles: false),
                            //             ),
                            //             bottomTitles: AxisTitles(
                            //               axisNameWidget: Text('Day of The Month',
                            //                 style: TextStyle(fontWeight: FontWeight.bold,height: 1.25 ),
                            //               ),
                            //               sideTitles: SideTitles(
                            //                 getTitlesWidget: bottomDailyTitles,
                            //                 showTitles: true,
                            //                 reservedSize: 25,
                            //                 //interval: 1,
                            //               ),
                            //             ),
                            //             leftTitles: AxisTitles(
                            //               axisNameWidget: Text('Amount ($selectedCurrency)',
                            //                   style: TextStyle(fontWeight: FontWeight.bold,),
                            //               ) ,
                            //               sideTitles: SideTitles(
                            //                 showTitles: true,
                            //                 // interval: 1,
                            //                 reservedSize: 35,
                            //               ),
                            //             ),
                            //           ),
                            //           // backgroundColor: Colors.black12,
                            //           // minX: 0,
                            //           // maxX: 31,
                            //           minY: 0,
                            //           // maxY: 25,
                            //         barGroups: barData,
                            //           )),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: screenH * 0.03,
                            // ),
                            // Container(decoration: BoxDecoration(
                            //   //color: Colors.white
                            // ),
                            //   height: screenH * 0.05,
                            //   width: screenW,
                            //   child: Center(
                            //     child: Text('Monthly Expenses',
                            //       style: TextStyle(fontWeight: FontWeight.bold,
                            //           fontSize: 25),
                            //     ),
                            //   ),
                            // ),
                            // Container(
                            //   width: screenW * 0.98,
                            //   height: screenH * 0.50,
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: Colors.black12,
                            //       width: 2,
                            //     ),
                            //     borderRadius: BorderRadius.circular(10),
                            //     color: Colors.white,
                            //   ),
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(top: 20.0),
                            //     child: BarChart(
                            //       BarChartData(
                            //           borderData: FlBorderData(
                            //           border: const Border(
                            //             bottom: BorderSide(),
                            //             left: BorderSide()
                            //           ),
                            //             ),
                            //         alignment: BarChartAlignment.center,
                            //         groupsSpace:16,
                            //         gridData: FlGridData(
                            //           show: true,
                            //           drawVerticalLine: false,
                            //           drawHorizontalLine: true,
                            //           // horizontalInterval: 10,
                            //           getDrawingHorizontalLine: (value) {
                            //             return FlLine(
                            //               color: Colors.grey,
                            //               strokeWidth: 1,
                            //             );
                            //           },
                            //         ),
                            //         titlesData: FlTitlesData(
                            //           show: true,
                            //           rightTitles: AxisTitles(
                            //             sideTitles:
                            //             SideTitles(showTitles: false),
                            //           ),
                            //           topTitles: AxisTitles(
                            //             sideTitles:
                            //             SideTitles(showTitles: false),
                            //           ),
                            //           bottomTitles: AxisTitles(
                            //             axisNameWidget: Text('Month',
                            //               style: TextStyle(fontWeight: FontWeight.bold, ),
                            //             ),
                            //             sideTitles: SideTitles(
                            //               showTitles: true,
                            //               reservedSize: 35,
                            //               interval: 1,
                            //               getTitlesWidget: bottomMonthTitles
                            //             ),
                            //           ),
                            //           leftTitles: AxisTitles(
                            //             axisNameWidget: Text('Amount ($selectedCurrency)',
                            //               style: TextStyle(fontWeight: FontWeight.bold,),
                            //             ) ,
                            //             sideTitles: SideTitles(
                            //               showTitles: true,
                            //               // interval: 1,
                            //               reservedSize: 35,
                            //             ),
                            //           ),
                            //         ),
                            //         barGroups: monthlyBarData,
                            //         minY: 0
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: screenH * 0.02,
                            ),
                          ],
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    })
              ],
            ),
          )),
    );
  }
}
