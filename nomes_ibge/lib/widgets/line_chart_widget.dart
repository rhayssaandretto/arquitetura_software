import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<List<FlSpot>> spotsList;
  final List<String> periodLabels;
  final List<Color> chartColors;
  final double height;
  final double width;
  final double maxY;

  const LineChartWidget({
    super.key,
    required this.spotsList,
    required this.periodLabels,
    required this.chartColors,
    this.width = 180,
    this.height = 180,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (periodLabels.length - 1).toDouble(),
          minY: 0,
          maxY: maxY,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < periodLabels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        periodLabels[idx],
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (maxY / 5).ceilToDouble(),
                getTitlesWidget: (value, _) {
                  if (value == 0) return const SizedBox.shrink();
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.grey, width: 0.5),
              bottom: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          lineBarsData: List.generate(spotsList.length, (i) {
            return LineChartBarData(
              spots: spotsList[i],
              isCurved: true,
              barWidth: 2,
              color: chartColors[i % chartColors.length],
              dotData: FlDotData(show: false),
            );
          }),
          clipData: FlClipData.all(),
        ),
      ),
    );
  }
}
