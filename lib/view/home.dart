import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iqg_machine_test/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();

    startGeneratingData();

    Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      refreshChart();
    });
  }

  void startGeneratingData() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        double currentPrice = 100 + Random().nextDouble() * 10;
        double high = currentPrice + Random().nextDouble() * 5;
        double low = currentPrice - Random().nextDouble() * 5;
        double open = currentPrice - Random().nextDouble() * 2;
        double close = currentPrice + Random().nextDouble() * 2;

        ChartData newChartData = ChartData(
          timeStamp: DateTime.now(),
          open: open,
          high: high,
          low: low,
          close: close,
        );

        chartData.add(newChartData);

        if (chartData.length > 10) {
          chartData.removeAt(0);
        }
      });
    });
  }

  void refreshChart() {
    setState(() {
      chartData.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Candlestick Chart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            opposedPosition: true,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          series: <CandleSeries<ChartData, DateTime>>[
            CandleSeries<ChartData, DateTime>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.timeStamp,
              lowValueMapper: (ChartData data, _) => data.low,
              highValueMapper: (ChartData data, _) => data.high,
              openValueMapper: (ChartData data, _) => data.open,
              closeValueMapper: (ChartData data, _) => data.close,
              bearColor: Colors.red,
              bullColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
