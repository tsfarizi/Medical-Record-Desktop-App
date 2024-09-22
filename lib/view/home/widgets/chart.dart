import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:medgis_app/view/home/widgets/indicator.dart';
import 'package:medgis_app/utils/theme/color_scheme.dart';

class Chart extends StatefulWidget {
  final int totalPatients;
  final int malePatients;
  final int femalePatients;

  const Chart({
    super.key,
    required this.totalPatients,
    required this.malePatients,
    required this.femalePatients,
  });

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final malePercentage = widget.totalPatients == 0
        ? 0.0
        : (widget.malePatients / widget.totalPatients) * 100;
    final femalePercentage = widget.totalPatients == 0
        ? 0.0
        : (widget.femalePatients / widget.totalPatients) * 100;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Total Patients :"),
                  Text(
                    "${widget.totalPatients}",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Indicator(
                  color: colorScheme.primary,
                  text: 'Male (${widget.malePatients})',
                  isSquare: false,
                ),
                const SizedBox(height: 10),
                Indicator(
                  color: colorScheme.primaryContainer,
                  text: 'Female (${widget.femalePatients})',
                  isSquare: false,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 200,
          height: 200,
          child: widget.totalPatients > 0
              ? PieChart(
                  PieChartData(
                    sections:
                        _showingSections(malePercentage, femalePercentage),
                    centerSpaceRadius: 40,
                    sectionsSpace: 4,
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          if (pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null ||
                              widget.totalPatients == 0) {
                            setState(() {
                              touchedIndex = -1;
                            });
                            return;
                          }

                          setState(() {
                            if (!event.isInterestedForInteractions) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        });
                      },
                    ),
                    startDegreeOffset: 180,
                    borderData: FlBorderData(show: false),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "No Data Available",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _showingSections(
      double malePercentage, double femalePercentage) {
    if (widget.totalPatients == 0) {
      return [];
    }

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25.0 : 16.0;
      final double radius = isTouched ? 60.0 : 50.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: colorScheme.primary,
            value: malePercentage,
            title: '${malePercentage.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
              shadows: [Shadow(color: colorScheme.onPrimary, blurRadius: 2)],
            ),
          );
        case 1:
          return PieChartSectionData(
            color: colorScheme.primaryContainer,
            value: femalePercentage,
            title: '${femalePercentage.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
              shadows: [
                Shadow(color: colorScheme.onPrimaryContainer, blurRadius: 2)
              ],
            ),
          );
        default:
          throw Error();
      }
    }).where((section) => section.value > 0).toList();
  }
}
