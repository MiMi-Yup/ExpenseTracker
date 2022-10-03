import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

abstract class LineChart1 extends StatelessWidget {
  Map<Color, List<FlSpot>> lines;
  bool showBarData;
  double maxX = 0.0;
  double maxY = 0.0;
  String? currency;
  double coefficientMoney = 1;
  LineChart1(
      {required this.lines,
      required this.showBarData,
      required this.currency}) {
    maxX = _maxX;
    maxY = _maxY;
  }

  double paddingRight = 16;
  double paddingTop = 16;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop, right: paddingRight),
      child: LineChart(
        sampleData1,
        swapAnimationDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  double get _maxX;

  double get _maxY {
    double result = 0;
    for (List<FlSpot> points in lines.values) {
      for (FlSpot point in points) {
        if (result < point.y) {
          result = point.y;
        }
      }
    }
    return double.parse((result * coefficientMoney).toStringAsFixed(0)) + 1;
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineChartBarData,
        minX: 0,
        maxX: maxX,
        maxY: maxY,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    bool isUnit = value.toInt() == maxY.toInt();
    TextStyle style = TextStyle(
      color: isUnit ? Colors.white : Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    text = isUnit ? currency ?? "" : value.toInt().toString();

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta);

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  List<LineChartBarData> get lineChartBarData => lines.keys
      .map((e) => LineChartBarData(
            isCurved: true,
            color: e,
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
                show: showBarData,
                color: showBarData ? e.withOpacity(0.5) : null),
            spots: lines[e]
                ?.map((e) => FlSpot(e.x,
                    double.parse((e.y * coefficientMoney).toStringAsFixed(2))))
                .toList(),
          ))
      .toList();
}

class TodayLineChart extends LineChart1 {
  TodayLineChart(
      {required super.lines,
      required super.showBarData,
      required super.currency});

  final hourPerDay = 24;
  final placeHolderForUnitHorizontal = 3;

  @override
  double get _maxX => hourPerDay.toDouble() + placeHolderForUnitHorizontal;

  @override
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    int _value = value.toInt();
    bool isUnit = _value == maxX.toInt();
    TextStyle style = TextStyle(
      color: isUnit ? Colors.white : Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (isUnit) {
      text = Text(
        "Hour",
        style: style,
      );
    } else if (_value % 2 == 0 && _value <= hourPerDay) {
      text = Text(_value.toString(), style: style);
    } else
      text = SizedBox();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
}

class WeekLineChart extends LineChart1 {
  WeekLineChart(
      {required super.lines,
      required super.showBarData,
      required super.currency});

  final weekPerMonth = 4;
  final placeHolderForUnitHorizontal = 1;

  @override
  double get _maxX => weekPerMonth.toDouble() + placeHolderForUnitHorizontal;

  @override
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    int _value = value.toInt();
    bool isUnit = _value == maxX.toInt();
    TextStyle style = TextStyle(
      color: isUnit ? Colors.white : Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (isUnit) {
      text = Text(
        "Week",
        style: style,
      );
    } else if (_value <= weekPerMonth) {
      text = Text(_value.toString(), style: style);
    } else
      text = SizedBox();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
}

class MonthLineChart extends LineChart1 {
  MonthLineChart(
      {required super.lines,
      required super.showBarData,
      required super.currency}) {
    paddingRight = 20;
  }

  final monthPerYear = 12;
  final placeHolderForUnitHorizontal = 2;

  @override
  double get _maxX => monthPerYear.toDouble() + placeHolderForUnitHorizontal;

  @override
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    int _value = value.toInt();
    bool isUnit = _value == maxX.toInt();
    TextStyle style = TextStyle(
      color: isUnit ? Colors.white : Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (isUnit) {
      text = Text(
        "Month",
        style: style,
      );
    } else if (_value <= monthPerYear) {
      text = Text(_value.toString(), style: style);
    } else
      text = SizedBox();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
}

class PieChartImage extends StatefulWidget {
  const PieChartImage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartImageState();
}

class PieChartImageState extends State {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
              pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              }),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              sections: showingSections()),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              IconAsset.income,
              size: widgetSize,
              borderColor: const Color(0xff0293ee),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              IconAsset.income,
              size: widgetSize,
              borderColor: const Color(0xfff8b250),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 16,
            title: '16%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              IconAsset.income,
              size: widgetSize,
              borderColor: const Color(0xff845bef),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              IconAsset.income,
              size: widgetSize,
              borderColor: const Color(0xff13d38e),
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw 'Oh no';
      }
    });
  }
}

class _Badge extends StatelessWidget {
  final String svgAsset;
  final double size;
  final Color borderColor;

  const _Badge(
    this.svgAsset, {
    Key? key,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Image.asset(
          svgAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
