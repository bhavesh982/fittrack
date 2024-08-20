import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WorkoutProgressChart extends StatelessWidget {
  final Map<String, dynamic> workoutData;

  WorkoutProgressChart({required this.workoutData});

  @override
  Widget build(BuildContext context) {
    final squatData = generateWeeklyProgressSpots(workoutData, 'SQUAT');
    final benchPressData = generateWeeklyProgressSpots(workoutData, 'BENCH PRESS');
    final deadliftData = generateWeeklyProgressSpots(workoutData, 'DEADLIFT');

    return Container(
      color: Colors.black, // Background color
      child: Column(
        children: [
          SizedBox(
            height: 400, // Increased height for the chart
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40, // Space for titles on the bottom
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          'W ${value.toInt() + 1}',
                          style: TextStyle(fontSize: 12, color: Colors.white), // White text color
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50, // Space for titles on the left
                      interval: 100, // Adjust interval if needed
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()} kg',
                          style: TextStyle(fontSize: 12, color: Colors.white), // White text color
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.white)), // White border color
                lineBarsData: [
                  LineChartBarData(
                    spots: squatData,
                    isCurved: true,
                    color: Colors.blue,
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: benchPressData,
                    isCurved: true,
                    color: Colors.red,
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: deadliftData,
                    isCurved: true,
                    color: Colors.green,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          // Legend
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LegendItem(color: Colors.blue, text: 'Squat Volume Progress'),
              SizedBox(width: 10),
              LegendItem(color: Colors.red, text: 'Bench Press Volume Progress'),
              SizedBox(width: 10),
              LegendItem(color: Colors.green, text: 'Deadlift Volume Progress'),
            ],
          ),
          SizedBox(height: 20),
          // Descriptive Texts
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'This chart shows the progress of your major lifts (Squat, Bench Press, Deadlift) '
                  'over time. The X-axis represents the workout week( W1,W2... ), and the Y-axis shows the total '
                  'weight lifted for each exercise',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white), // White text color
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> generateWeeklyProgressSpots(Map<String, dynamic> workoutData, String exercise) {
    List<FlSpot> spots = [];
    int xValue = 0;

    workoutData['PROGRAM']?.forEach((week, weekData) {
      double weeklyTotalVolume = 0;
      int daysWithData = 0;

      weekData.forEach((day, dayData) {
        if (day != "completed" && !dayData['REST']) {
          if (dayData[exercise] != null) {
            double dailyTotalVolume = 0;
            dayData[exercise].forEach((set, setData) {
              double weight = double.tryParse(setData['weight']) ?? 0;
              int reps = setData['reps'] ?? 0;
              dailyTotalVolume += weight * reps;
            });
            weeklyTotalVolume += dailyTotalVolume;
            daysWithData++;
          }
        }
      });

      spots.add(FlSpot(xValue.toDouble(), daysWithData > 0 ? weeklyTotalVolume / daysWithData : 0));
      xValue++;
    });

    return spots;
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Colors.white), // White text color
        ),
      ],
    );
  }
}
