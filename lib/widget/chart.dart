import 'package:budgetdotai/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<Color> gradientColors = [primary];

LineChartData mainData() {
  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawHorizontalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(color: const Color(0xff37434d), strokeWidth: 0.1);
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTitlesWidget: (value, meta) => SideTitleWidget(
            space: 8,
            meta: meta,
            child: Text(
              value.toInt() == 2
                  ? '1'
                  : value.toInt() == 5
                  ? '11'
                  : value.toInt() == 8
                  ? '21'
                  : '',
              style: const TextStyle(color: Color(0xff68737d), fontSize: 12),
            ),
          ),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          getTitlesWidget: (value, meta) => SideTitleWidget(
            space: 12,
            meta: meta,
            child: Text(
              value.toInt() == 1
                  ? '10k'
                  : value.toInt() == 3
                  ? '50k'
                  : value.toInt() == 5
                  ? '100k'
                  : '',
              style: const TextStyle(color: Color(0xff67727d), fontSize: 12),
            ),
          ),
        ),
      ),
    ),
    borderData: FlBorderData(show: false),
    minX: 0,
    maxX: 11,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, 3),
          FlSpot(2.6, 2),
          FlSpot(4.9, 5),
          FlSpot(6.8, 3.1),
          FlSpot(8, 4),
          FlSpot(9.5, 3),
          FlSpot(11, 4),
        ],
        isCurved: true,
        color: gradientColors[0],
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
      ),
    ],
  );
}
