import 'dart:math';
import 'package:flutter/material.dart';
import 'time_chart/chart_widget.dart';
import 'time_chart/entity/ts_entity.dart';
import 'time_chart/entity/period_entity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatelessWidget {
  final GlobalKey<ChartWidgetState> _key = GlobalKey<ChartWidgetState>();
  final String title;
  HomePage({this.title});

  List<PeriodEntity> getDatas() {
    int cycleTime = 60;
    int startTime = 1586427900;
    var list = <PeriodEntity>[];
    for (int i = 0; i < 16; i++) {
      var period = PeriodEntity();
      var openTime = startTime + i * cycleTime;
      period.openTime = openTime;
      period.closeTime = openTime + cycleTime;

      var tss = <TsEntity>[];
      for (int n = 0; n <= cycleTime; n++) {
        tss.add(TsEntity(
          time: openTime + n,
          value: randomDouble(4),
        ));
      }
      period.tss = tss;
      list.add(period);
    }
    return list;
  }

  double randomDouble(int len) {
    String scopeF = '123456789'; //首位
    String scopeC = '0123456789'; //中间
    String result = '';
    for (int i = 0; i < len; i++) {
      if (i == 1) {
        result = scopeF[Random().nextInt(scopeF.length)];
      } else {
        result = result + scopeC[Random().nextInt(scopeC.length)];
      }
    }
    return (double.parse(result) - 500).abs();
  }

  @override
  Widget build(BuildContext context) {
    final datas = getDatas();
    final initIndex = datas.length - 1;
    int i = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            padding: EdgeInsets.all(10),
            child: ChartWidget(
              key: _key,
              datas: datas,
              initIndex: initIndex,
              onDrag: (int index) {
                print('----------index : $index----------------');
              },
            ),
          ),
          Wrap(
            spacing: 10,
            children: <Widget>[
              FlatButton(
                color: Colors.deepOrange,
                child: Text('add Period', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _key.currentState.addPeriod(
                    PeriodEntity(
                      openTime: 1586427900 + 16 * 60,
                      closeTime: 1586427900 + 17 * 60,
                    ),
                  );
                },
              ),
              FlatButton(
                color: Colors.deepOrange,
                child: Text('add Ts', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _key.currentState.addTs(
                    TsEntity(
                      time: 1586427900 + 16 * 60 + i,
                      value: (randomDouble(4) - 500).abs(),
                    ),
                  );
                  i++;
                },
              ),
              FlatButton(
                color: Colors.deepOrange,
                child: Text('select index=2', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _key.currentState.onSelect(2);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
