import 'package:flutter/material.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(28.0),
            child: Text("Welcome Admin!",
            style: TextStyle(
              color: Color(0xFF92959E)
            ),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {},
               child: Text("Houses\n 10"),
               style: ElevatedButton.styleFrom(
                fixedSize: const Size(230, 85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                )
               ),
               ),
               ElevatedButton(onPressed: () {},
               child: Text("Users\n 10"),
               style: ElevatedButton.styleFrom(
                primary: AppTheme.colors.mainLightPurpleColor,
                fixedSize: const Size(230, 85),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
               ),),
               ElevatedButton(onPressed: () {},
               child: Text("House Agent\n 0"),
                style: ElevatedButton.styleFrom(
                fixedSize: const Size(230, 85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                )
               ),)
            ],
          ),
          SizedBox(height: 50, width: 50,),
          Card(
            elevation: 16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 3,0,0),
              child: Container(
                margin: EdgeInsets.only(left: 20, top:10, right: 20, bottom:0),
                width: 700,
                child: SfCartesianChart(),
              ),
            )
          ),
        ],
      )
        ],)
    );
  }
}

List <SalesData> getChartData() {
  final List<SalesData> chartData = [
    SalesData(2017, 25),
    SalesData(2018, 12),
    SalesData(2019, 24),
    SalesData(2020, 18),
    SalesData(2021, 30)

  ];
  return chartData;
}

class SalesData{
  SalesData(this.year, this.sales);
  final double year;
  final double sales;
}