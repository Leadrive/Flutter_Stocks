import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystocks/Market/enity/Stock.dart';
import 'package:http/http.dart' as http;
import 'package:gbk2utf8/gbk2utf8.dart';

/**
 * @Description  行情界面
 * @Author  zhibuyu
 * @Date 2018/10/25  10:27
 * @Version  1.0
 */
class MarketPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MarketPageState();
}

class MarketPageState extends State<MarketPage> {
  List<Stock> stocks = [];

  @override
  Widget build(BuildContext context) {
    return new Center(child: getBody());
  }

  @override
  void initState() {
    getDatas();
  }

  void getDatas() {
    String url =
        "http://hq.sinajs.cn/list=sh601003,sh601001,sz002242,sz002230,sh603456,sz002736,sh600570";
    fetch(url).then((data) {
      setState(() {
        List<String> stockstrs = data.split(";");
        setState(() {
          for (int i = 0; i < (stockstrs.length - 1); i++) {
            String str = stockstrs[i];
            Stock stock = new Stock();
            DealStocks(str, stock);
            stocks.add(stock);
          }
        });
      });
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: "网络异常，请检查",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          bgcolor: "#OOOOOO",
          textcolor: '#ffffff');
    });
  }

  Future fetch(String url) async {
    http.Response response = await http.get(url);
    String str = decodeGbk(response.bodyBytes);
    return str;
  }

  /**
   * 处理股票数据
   */
  void DealStocks(String str, Stock stock) {
    int start = str.indexOf("\"") + 1;
    int end = str.indexOf("\"", start);
    stock.stock_code = str.substring(str.indexOf("str_") + 6, start - 2);
    String stock_str = str.substring(start, end);
    List stock_item = stock_str.split(",");
    stock.name = stock_item[0];
    stock.today_open = stock_item[1];
    stock.yesterday_close = stock_item[2];
    stock.current_prices = stock_item[3];
    stock.today_highest_price = stock_item[4];
    stock.today_lowest_price = stock_item[5];
    stock.buy1_j = stock_item[6];
    stock.sell1_j = stock_item[7];
    stock.traded_num = stock_item[8];
    stock.traded_amount = stock_item[9];
    stock.buy1_apply_num = stock_item[10];
    stock.buy1 = stock_item[11];
    stock.buy2_apply_num = stock_item[12];
    stock.buy2 = stock_item[13];
    stock.buy3_apply_num = stock_item[14];
    stock.buy3 = stock_item[15];
    stock.buy4_apply_num = stock_item[16];
    stock.buy4 = stock_item[17];
    stock.buy5_apply_num = stock_item[18];
    stock.buy5 = stock_item[19];
    stock.sell1_apply_num = stock_item[20];
    stock.sell1 = stock_item[21];
    stock.sell2_apply_num = stock_item[22];
    stock.sell2 = stock_item[23];
    stock.sell3_apply_num = stock_item[24];
    stock.sell3 = stock_item[25];
    stock.sell4_apply_num = stock_item[26];
    stock.sell4 = stock_item[27];
    stock.sell5_apply_num = stock_item[28];
    stock.sell5 = stock_item[29];
    stock.date = stock_item[30];
    stock.time = stock_item[31];
  }

  getBody() {
    if (stocks.isEmpty) {
      // 加载菊花
      return CircularProgressIndicator();
    } else {
      return new Container(
        child: getListView(),
        alignment: FractionalOffset.topLeft,
      );
    }
  }

  getListView() {
    return ListView.builder(
      itemCount: (stocks == null) ? 0 : stocks.length,
      itemBuilder: (BuildContext context, int position) {
        return getItem(position);
      },
      physics: new AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  getItem(int position) {
    Stock stock = stocks[position];
    return new GestureDetector(
        child: new Card(
          child: new Padding(
            padding: new EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //纵向对齐方式：起始边对齐
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Container(
                        child: new Text(
                          stock.name,
                          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                        alignment: FractionalOffset.topCenter,
                      ), new Container(
                        child: new Text(
                          stock.stock_code,
                          style: new TextStyle(fontSize: 16.0,),
                        ),
                        alignment: FractionalOffset.bottomCenter,
                      )
                    ],
                  ),
                  flex: 1,
                ),
                new Expanded(
                  child: new Container(
                    child: new Text(
                      stock.current_prices,
                      style: new TextStyle(fontSize: 18.0),
                    ), alignment: FractionalOffset.center,
                  ),
                  flex: 2,
                ),
                new Expanded(
                  child: new Container(
                    color: Colors.red,
                    padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                    child: new Text("+10.00%", style: new TextStyle(fontSize: 18.0),
                    ),
                    alignment: FractionalOffset.center,
                  ),
                  flex:1,
                )
              ],
            ),),
        ),
      onTap: () {},
    );
  }
}
