// ignore_for_file: prefer_const_constructors
//import 'dart:ffi';

import 'package:expense_tracker/edit.dart';
import 'package:expense_tracker/expensedatabase.dart';
import 'package:expense_tracker/input.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/settings.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MaterialApp(home: Trends()));
}

class Trends extends StatefulWidget {

  const Trends({Key? key}) : super(key: key);
  @override
  State<Trends> createState() => TrendsState();
}

class TrendsState extends State<Trends> {
  SqlDB sqlDB = SqlDB();

  String firstDate = '${DateTime.now().year}/${DateTime.now().month}/1';

  String startOfYear= '${DateTime.now().year}/1/1';

  String endOfYear= '${DateTime.now().year + 1}/1/1';

  String finalDate =
      '';// final date used in readData() sql, date of the first day of next month

  String todayExpensesValue= '0';

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

  // Map<String,double> expenseCategories= {
  //   'Fuel': 0.0,'Grocery': 0.0,'Cafe': 0.0,'Restaurant': 0.0,'Shopping': 0.0,
  //   'Medicine': 0.0,'GYM': 0.0,'Sports': 0.0,'Parking': 0.0,'Utilities': 0.0,'Mobile Bill': 0.0,'Other': 0.0 } ;

  // getCategories() async {
  //
  //   List expenseCat= await sqlDB.readData('''
  //   SELECT category,SUM(amount) FROM expensesTable WHERE date BETWEEN '$firstDate' AND '$finalDate' GROUP BY category ''');
  //
  //   var categoriesList= expenseCat.toList();
  //
  //   for (var element in categoriesList) {
  //     if(element['category']== 'Fuel') {
  //       expenseCategories.update('Fuel', (value) => element['SUM(amount)']);
  //     }
  //     if(element['category']== 'Grocery') {
  //       expenseCategories.update('Grocery', (value) => element['SUM(amount)']);
  //     }
  //     if(element['category']== 'Cafe') {
  //       expenseCategories.update('Cafe', (value) => element['SUM(amount)']);
  //     }
  //     if(element['category']== 'Restaurant') {
  //       expenseCategories.update('Restaurant', (value) => element['SUM(amount)']);
  //     }
  //     if(element['category']== 'Shopping') {
  //       expenseCategories.update('Shopping', (value) => element['SUM(amount)']);
  //     }
  //     if(element['category']== 'Medicine') {
  //       expenseCategories.update('Medicine', (value) => element['SUM(amount)']);
  //     }
  //     if(element['category']== 'GYM') {
  //       expenseCategories.update('GYM', (value) => element['SUM(amount)']);
  //     }
  //     if(element['category']== 'Sports') {
  //       expenseCategories.update('Sports', (value) => element['SUM(amount)']);
  //     }
  //     if(element['category']== 'Parking') {
  //       expenseCategories.update('Parking', (value) => element['SUM(amount)']);
  //     }
  //     if(element['category']== 'Utilities') {
  //       expenseCategories.update('Utilities', (value) => element['SUM(amount)']);
  //     }
  //     if(element['category']== 'Mobile Bill') {
  //       expenseCategories.update('Mobile Bill', (value) => element['SUM(amount)']);
  //     }
  //     if(element['category']== 'Other') {
  //       expenseCategories.update('Other', (value) => element['SUM(amount)']);
  //     }
  //   }
  // }

  List<BarChartGroupData> barData= [
    BarChartGroupData(x: 0, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 1, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 2, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 3, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 4, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 5, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 6, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 7, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 8, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 9, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 10, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 11, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 12, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 13, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 14, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 15, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 16, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 17, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 18, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 19, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 20, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 21, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 22, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 23, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 24, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 25, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 26, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 27, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 28, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 29, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 30, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 31, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),

  ];

  List<BarChartGroupData> monthlyBarData= [
    BarChartGroupData(x: 0, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 1, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 2, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 3, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 4, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 5, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 6, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 7, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 8, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 9, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 10, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 11, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)]),
    BarChartGroupData(x: 12, groupVertically: false, barRods: [BarChartRodData(fromY: 0,toY: 0)])];

  addExpensesList() async {
    List expenses = await sqlDB.readData('''
                        SELECT date,SUM(amount) 
                        FROM expensesTable 
                        WHERE date BETWEEN "$firstDate" AND "$finalDate" 
                        GROUP BY date''');

    List monthlyExpenses = await sqlDB.readData('''
                        SELECT SUBSTR(date,6,2) as Month,SUM(amount) 
                        FROM expensesTable 
                        WHERE date BETWEEN "$startOfYear" AND "$endOfYear" 
                        GROUP BY Month''');


    var expensesList = expenses.toList();

    var monthlyExpensesList= monthlyExpenses.toList();


    expensesList.forEach((element) {
      int i=1;
      while(i<32) {
        if (element['date'] ==
            '${DateTime.now().year}/${DateTime.now().month}/$i') {
          setState(() {
            barData[i]=BarChartGroupData(x: i,groupVertically: false,barRods: [BarChartRodData(fromY:0, toY: element['SUM(amount)'])]);
          });
          //barData[i]=BarChartGroupData(x: i,groupVertically: false,barRods: [BarChartRodData(fromY:0, toY: element['SUM(amount)'])]);
          break;
        } else {
          i++;
        }
      }

      print('monthly expenses are: $monthlyExpensesList');

      monthlyExpensesList.forEach((element) {
        if (element['Month']=='1/') {
          setState(() {
          monthlyBarData[1]=BarChartGroupData(x: 1,groupVertically: false,barRods: [BarChartRodData(fromY: 0, toY: element['SUM(amount)'])]);
          });
        }
        if (element['Month']=='2/') {
          monthlyBarData[2]=BarChartGroupData(x: 2,groupVertically: false,barRods: [BarChartRodData(fromY: 0, toY: element['SUM(amount)'])]);
        }
        if (element['Month']=='3/') {
          monthlyBarData[3]=BarChartGroupData(x: 3,groupVertically: false,barRods: [BarChartRodData(fromY: 0, toY: element['SUM(amount)'])]);
        }
        if (element['Month']=='4/') {
          monthlyBarData[4]=BarChartGroupData(x: 4,groupVertically: false,barRods: [BarChartRodData(fromY: 0, toY: element['SUM(amount)'])]);
        }
        if (element['Month']=='5/') {
          monthlyBarData[5]=BarChartGroupData(x: 5,groupVertically: false,barRods: [BarChartRodData(fromY: 0, toY: element['SUM(amount)'])]);
        }
        if (element['Month']=='6/') {
          monthlyBarData[6]=BarChartGroupData(x: 6,groupVertically: false,barRods: [BarChartRodData(fromY: 0, toY: element['SUM(amount)'])]);
        }
        if (element['Month']=='7/') {
          monthlyBarData[7]=BarChartGroupData(x: 7,groupVertically: false,barRods: [BarChartRodData(fromY: 0, toY: element['SUM(amount)'])]);
        }
        if (element['Month']=='8/') {
          monthlyBarData[8]=BarChartGroupData(x: 8,groupVertically: false,barRods: [BarChartRodData(fromY: 0, toY: element['SUM(amount)'])]);
        }
        if (element['Month']=='9/') {
          monthlyBarData[9]=BarChartGroupData(x: 9,groupVertically: false,barRods: [BarChartRodData(fromY: 0, toY: element['SUM(amount)'])]);
        }
        if (element['Month']=='10') {
          monthlyBarData[10]=BarChartGroupData(x: 10,groupVertically: false,barRods: [BarChartRodData(fromY: 0, toY: element['SUM(amount)'])]);
        }
        if (element['Month']=='11') {
          monthlyBarData[11]=BarChartGroupData(x: 11,groupVertically: false,barRods: [BarChartRodData(fromY: 0, toY: element['SUM(amount)'])]);
        }
        if (element['Month']=='12') {
          monthlyBarData[12]=BarChartGroupData(x: 12,groupVertically: false,barRods: [BarChartRodData(fromY: 0, toY: element['SUM(amount)'])]);
        }
      }
      );
    },
    );
  }

  String? targetExpense ;
  String? selectedCurrency;
  double allowedSpending= 0 ;

  getSettings() async {
    List settingsData= await sqlDB.readData('SELECT * FROM settingsTable');

    targetExpense=settingsData.elementAt(0)['target'].toString();
    selectedCurrency=settingsData.elementAt(0)['currency'];
    allowedSpending=(settingsData.elementAt(0)['target']/30) * duration;

    print('Settings List: $settingsData');
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
    return response;
  }


  @override
  void initState() {
    super.initState();
    //Future.delayed(Duration.zero, () => addExpensesList());
    WidgetsBinding.instance.addPostFrameCallback((_) => addExpensesList());
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width; // width of the screen
    double screenH = MediaQuery.of(context).size.height; // height of the screen
    getCurrentDate();
    calcDays();
    //getCategories();
    getSettings();
    //addExpensesList();
    int navBarIndex= 1;

    return MaterialApp(
      theme: ThemeData(fontFamily: 'RobotoCondensed-Light'),
      home: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Input()),
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
                  MaterialPageRoute(builder: (context) => MyApp()),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  Settings(
                    target: targetExpense.toString(),
                    currency: selectedCurrency,
                  )),
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
            title:  Center(child: Text('Expenses Trends',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
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
                              height: screenH * 0.03,
                            ),
                            Container(decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white
                            ),
                              height: screenH * 0.05,
                              width: screenW * 0.95,
                              child: Center(
                                child: Text('Current Month',
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black26,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    width: screenW * 1.25 ,
                                    height: screenH * 0.5,
                                    margin: EdgeInsets.only(left: 6,top: 1) ,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: BarChart(BarChartData(
                                        borderData: FlBorderData(
                                          border: const Border(
                                              bottom: BorderSide(
                                                width: 2,
                                              ),
                                              left: BorderSide(
                                                width: 2
                                              )),
                                        ),
                                        alignment: BarChartAlignment.center,
                                        groupsSpace:5,
                                        gridData: FlGridData(
                                          show: true,
                                          drawVerticalLine: false,
                                          drawHorizontalLine: true,
                                          // horizontalInterval: 10,
                                          getDrawingHorizontalLine: (value) {
                                            return FlLine(
                                              color: Colors.grey,
                                              strokeWidth: 1,
                                            );
                                          },
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          rightTitles: AxisTitles(
                                            sideTitles:
                                            SideTitles(showTitles: false),
                                          ),
                                          topTitles: AxisTitles(
                                            sideTitles:
                                            SideTitles(showTitles: false),
                                          ),
                                          bottomTitles: AxisTitles(
                                            axisNameWidget: Text('Day of The Month',
                                              style: TextStyle(fontWeight: FontWeight.bold,height: 1.25 ),
                                            ),
                                            sideTitles: SideTitles(
                                              getTitlesWidget: bottomDailyTitles,
                                              showTitles: true,
                                              reservedSize: 25,
                                              //interval: 1,
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            axisNameWidget: Text('Amount ($selectedCurrency)',
                                              style: TextStyle(fontWeight: FontWeight.bold,),
                                            ) ,
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              // interval: 1,
                                              reservedSize: 40,
                                            ),
                                          ),
                                        ),
                                        // backgroundColor: Colors.black12,
                                        // minX: 0,
                                        // maxX: 31,
                                        minY: 0,
                                        // maxY: 25,
                                        barGroups: barData,
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenH * 0.03,
                            ),
                            Container(decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                            ),
                              height: screenH * 0.05,
                              width: screenW * 0.95,
                              child: Center(
                                child: Text('Monthly Expenses',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  width: screenW * 0.95,
                                  height: screenH * 0.50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black26,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0,right: 10),
                                    child: BarChart(
                                      BarChartData(
                                          borderData: FlBorderData(
                                            border: const Border(
                                                bottom: BorderSide(
                                                  width: 2
                                                ),
                                                left: BorderSide(
                                                    width: 2
                                                )
                                            ),
                                          ),
                                          alignment: BarChartAlignment.center,
                                          groupsSpace:16,
                                          gridData: FlGridData(
                                            show: true,
                                            drawVerticalLine: false,
                                            drawHorizontalLine: true,
                                            // horizontalInterval: 10,
                                            getDrawingHorizontalLine: (value) {
                                              return FlLine(
                                                color: Colors.grey,
                                                strokeWidth: 1,
                                              );
                                            },
                                          ),
                                          titlesData: FlTitlesData(
                                            show: true,
                                            rightTitles: AxisTitles(
                                              sideTitles:
                                              SideTitles(showTitles: false),
                                            ),
                                            topTitles: AxisTitles(
                                              sideTitles:
                                              SideTitles(showTitles: false),
                                            ),
                                            bottomTitles: AxisTitles(
                                              axisNameWidget: Text('Month',
                                                style: TextStyle(fontWeight: FontWeight.bold, ),
                                              ),
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  interval: 1,
                                                  getTitlesWidget: bottomMonthTitles
                                              ),
                                            ),
                                            leftTitles: AxisTitles(
                                              axisNameWidget: Text('Amount ($selectedCurrency)',
                                                style: TextStyle(fontWeight: FontWeight.bold,),
                                              ) ,
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                // interval: 1,
                                                reservedSize: 40,
                                              ),
                                            ),
                                          ),
                                          barGroups: monthlyBarData,
                                          minY: 0
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenH * 0.09,
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
