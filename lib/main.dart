import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class CustomTable extends StatelessWidget {
  List orders;

  CustomTable(this.orders);

  @override
  Widget build(BuildContext context) {
    var widthGrid = MediaQuery.of(context).size.width;
    var heightGrid = MediaQuery.of(context).size.height;

    var drawBox = <TableRow>[];
    var row = <Widget>[];
    var boxCount = 0;
    var boxNumber = 1;
    var boxes = 12;

    for (var index = 0; index < boxes; index++) {
      var order;
      if (index >= 0 && index < orders.length) {
        order = orders[index];
      }
      row.add(gridCell(order, boxNumber, heightGrid.toInt()));
      boxCount++;
      boxNumber++;
      if (boxCount == 6) {
        drawBox.add(TableRow(children: row));
        row = [];
      }
    }
    drawBox.add(TableRow(children: row));

    return MaterialApp(
      home: Scaffold(
        body: Container(
          height: heightGrid,
          width: widthGrid,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: drawBox,
          ),
        ),
      ),
    );
  }

  Widget gridCell(dynamic order, int boxNumber, int heightGrid) {
    final orderId = order != null ? "Order ID:" + order['orderId'] : '';
    final pickupTime = order != null ? order['pickupTime'] : '';

    final BoxDecoration decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      border: Border.all(),
    );

    return TableCell(
      child: Container(
        decoration: decoration,
        height: heightGrid * 0.5,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              color: Colors.amber,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Text(boxNumber.toString()),
            ),
            Container(
              // color: Colors.green,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                orderId,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              // color: Colors.redAccent,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Text(pickupTime),
            ),
          ],
        ),
      ),
    );
  }
}

// order
class Order {
  String orderId;
  List dishes = [];
  DateTime pickupTime;

  Order(
      {required this.orderId, required this.dishes, required this.pickupTime});

  factory Order.fromJson(Map json) {
    List dishJsonList = json['dishes'];
    List dishList =
        dishJsonList.map((dishJson) => Dish.fromJson(dishJson)).toList();

    return Order(
      orderId: json['orderId'],
      dishes: dishList,
      pickupTime: DateTime.parse(json['pickupTime']),
    );
  }

  Map toJson() {
    List dishJsonList = dishes.map((dish) => dish.toJson()).toList();

    return {
      'orderId': orderId,
      'dishes': dishJsonList,
      'pickupTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(pickupTime),
    };
  }
}

class Dish {
  String dishName;

  Dish({required this.dishName});

  factory Dish.fromJson(Map json) {
    return Dish(
      dishName: json['dishName'],
    );
  }

  Map toJson() {
    return {
      'dishName': dishName,
    };
  }
}

void main() {
  Random random = Random();
  DateTime now = DateTime.now();
  var orders = [];

  for (var i = 0; i < 2 + random.nextInt(10); i++) {
    DateTime pickupTime = now.add(Duration(seconds: 1 + random.nextInt(300)));
    Order order = Order(
      orderId: (1000 + random.nextInt(10)).toString(),
      dishes: [
        Dish(dishName: 'PizzaType$i'),
        Dish(dishName: 'BurgerType$i'),
        Dish(dishName: 'SaladType$i'),
      ],
      pickupTime: pickupTime,
    );
    orders.insert(i, order.toJson());
  }
  runApp(CustomTable(orders));
}
