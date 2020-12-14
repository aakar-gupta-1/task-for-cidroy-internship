import 'package:cidroy/Models/album.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:toggle_switch/toggle_switch.dart';

class ChartsDemo extends StatefulWidget {
  final Album data;
  //
  ChartsDemo(this.data) : super();

  @override
  ChartsDemoState createState() => ChartsDemoState(data);
}

List<Vehicle> generateDaily(Album vehicleData, int a){
  return [
    Vehicle('Mon', vehicleData.daily[0]['Mon'][a]),
    Vehicle('Tue', vehicleData.daily[0]['Tue'][a]),
    Vehicle('Wed', vehicleData.daily[0]['Wed'][a]),
    Vehicle('Thu', vehicleData.daily[0]['Thu'][a]),
    Vehicle('Fri', vehicleData.daily[0]['Fri'][a]),
    Vehicle('Sat', vehicleData.daily[0]['Sat'][a]),
    Vehicle('Sun', vehicleData.daily[0]['Sun'][a]),
  ];
}
List<Vehicle> generateHourly(Album vehicleData, int a){
  return [
    Vehicle('8am', vehicleData.hourly[0]['8am'][a]),
    Vehicle('10am', vehicleData.hourly[0]['10am'][a]),
    Vehicle('12am', vehicleData.hourly[0]['12am'][a]),
    Vehicle('2pm', vehicleData.hourly[0]['2pm'][a]),
    Vehicle('4pm', vehicleData.hourly[0]['4pm'][a]),
    Vehicle('6pm', vehicleData.hourly[0]['6pm'][a]),
    Vehicle('8pm', vehicleData.hourly[0]['8pm'][a]),
  ];
}

class ChartsDemoState extends State<ChartsDemo> {
  //
  final Album vehicleData;
  int toggle=0;
  List<charts.Series> seriesList;

  ChartsDemoState(this.vehicleData);

  List<charts.Series<Vehicle, String>> _createData() {

    List<Vehicle> twoWheeler;
    List<Vehicle> fourWheeler;
    List<Vehicle> bus;

    if(toggle==0) {
      twoWheeler = generateDaily(vehicleData, 0);
      fourWheeler = generateDaily(vehicleData, 1);
      bus = generateDaily(vehicleData, 2);
    }else if(toggle==1){
      twoWheeler = generateHourly(vehicleData, 0);
      fourWheeler = generateHourly(vehicleData, 1);
      bus = generateHourly(vehicleData, 2);
    }

    return [
      charts.Series<Vehicle, String>(
        id: '2 Wheeler',
        domainFn: (Vehicle cross, _) => cross.timeDay,
        measureFn: (Vehicle cross, _) => cross.value,
        data: twoWheeler,
      ),
      charts.Series<Vehicle, String>(
        id: '4 Wheeler',
        domainFn: (Vehicle cross, _) => cross.timeDay,
        measureFn: (Vehicle cross, _) => cross.value,
        data: fourWheeler,
      ),
      charts.Series<Vehicle, String>(
        id: 'Bus',
        domainFn: (Vehicle cross, _) => cross.timeDay,
        measureFn: (Vehicle cross, _) => cross.value,
        data: bus,
      )
    ];
  }

  barChart() {
    return charts.BarChart(
      seriesList,
      vertical: true,
      animate: true,
      barGroupingType: charts.BarGroupingType.stacked,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.stacked,
        strokeWidthPx: 1.0,
      ),
      behaviors: [new charts.SeriesLegend()],
    );
  }

  @override
  void initState() {
    super.initState();
    seriesList = _createData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              // height: 400,
              padding: EdgeInsets.all(20.0),
              child: barChart(),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ToggleSwitch(
            minHeight: 40,
            minWidth: 90,
            initialLabelIndex: toggle,
            labels: ['Daily', 'Hourly'],
            onToggle: (index) {
              setState(() {
                toggle=index;
                seriesList=_createData();
              });
              print(toggle);
            },
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}

class Vehicle {
  final String timeDay;
  final int value;

  Vehicle(this.timeDay, this.value);
}