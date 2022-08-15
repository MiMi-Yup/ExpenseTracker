import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/widget/largest_button.dart';
import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                  floating: true,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.3,
                  leading: IconButton(
                      onPressed: null, icon: Icon(Icons.arrow_back_ios)),
                  centerTitle: true,
                  backgroundColor: MyColor.mainBackgroundColor,
                  elevation: 0.0,
                  flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Image.asset(
                        "asset/image/background_wallet_page.png",
                        isAntiAlias: true,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Wallet Balance",
                              style: TextStyle(fontSize: 30)),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text("\$6400", style: TextStyle(fontSize: 16))
                        ],
                      )
                    ],
                  ))),
              SliverList(
                  delegate: SliverChildListDelegate(
                      List.generate(
                          50,
                          (index) => GestureDetector(
                                onTap: null,
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  color:
                                                      MyColor.purpleTranparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.wallet,
                                                color: MyColor.purple(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 16.0,
                                            ),
                                            Text("Wallet")
                                          ]),
                                      Text("\$50")
                                    ],
                                  ),
                                ),
                              )),
                      addSemanticIndexes: false))
            ],
          ),
        ),
        Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(16.0),
          child: largestButton(text: "+ Add new wallet", onPressed: () => null),
        )
      ],
    ));
  }
}
