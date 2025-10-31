
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FrequencyChart extends StatelessWidget {
  final Map<String, int> data;
  const FrequencyChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final series = [
      charts.Series<MapEntry<String, int>, String>(
        id: 'DigitFreq',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (e, _) => e.key,
        measureFn: (e, _) => e.value,
        data: entries,
        labelAccessorFn: (e, _) => '${e.value}',
      )
    ];

    return SizedBox(
      height: 250,
      child: charts.BarChart(
        series,
        animate: true,
        behaviors: [
          charts.ChartTitle('Frekuensi Digit 0–9'),
          charts.BarLabelDecorator<String>(),
        ],
        domainAxis: const charts.OrdinalAxisSpec(),
      ),
    );
  }
}
