import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/widget/largest_button.dart';
import 'package:flutter/material.dart';

class DetailTransaction extends StatefulWidget {
  DetailTransaction({Key? key}) : super(key: key);

  @override
  State<DetailTransaction> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTransaction> {
  final heightAnchor = 75.0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(children: [
      Container(
        width: double.maxFinite,
        height: size.height / 3,
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading:
                  IconButton(onPressed: null, icon: Icon(Icons.arrow_back_ios)),
              title: Text("Detail Transaction"),
              actions: [
                IconButton(
                    onPressed: null, icon: Icon(Icons.delete_forever_rounded))
              ],
              centerTitle: true,
            ),
            Text(
              "\$5000",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Text(
              "Purpose",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              DateTime.now().toString(),
              style: TextStyle(fontSize: 16, color: Colors.white70),
            )
          ],
        ),
      ),
      Container(
        height: heightAnchor,
        margin: EdgeInsets.only(
            top: size.height / 3 - heightAnchor / 2, left: 25.0, right: 25.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0), color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Type", style: TextStyle(color: Colors.grey)),
                SizedBox(
                  height: 20.0,
                ),
                Text("Expense", style: TextStyle(color: Colors.black))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Type", style: TextStyle(color: Colors.grey)),
                SizedBox(
                  height: 20.0,
                ),
                Text("Expense", style: TextStyle(color: Colors.black))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Type", style: TextStyle(color: Colors.grey)),
                SizedBox(
                  height: 20.0,
                ),
                Text("Expense", style: TextStyle(color: Colors.black))
              ],
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            top: size.height / 3 + heightAnchor / 2, left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                    10,
                    (index) => Container(
                          height: 4.0,
                          width: size.width / 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              color: Colors.white),
                        )),
              ),
            ),
            Text(
              "Description",
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              "Amet minim mollit non deserunt ullamco est sit aliqua dhfkadhfkdskjfhkdshfkjsdhkfhskdasjd,mas,dm sadksalkdj aslkdjsak dlsakdjldkjfhksdfhkdshfkdjshfkdsjhfalduowqiuroiwqruqwoiruwqrkasjflkasjolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
              maxLines: 5,
              style: TextStyle(fontSize: 18),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            Text("Attachment", style: TextStyle(color: Colors.white70)),
            Container(
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
              child: Image.asset("asset/image/success.png", fit: BoxFit.fill),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    width: double.maxFinite,
                    child: largestButton(text: "Edit", onPressed: () => null)),
              ),
            )
          ],
        ),
      )
    ]));
  }
}
