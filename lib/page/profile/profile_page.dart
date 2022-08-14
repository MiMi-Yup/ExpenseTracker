import 'package:expense_tracker/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("asset/image/income.png"),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    children: [
                      Text(
                        "Username",
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "Iriana Saliha",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
              IconButton(onPressed: null, icon: Icon(Icons.edit))
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(16.0)),
            child: Column(
              children: List.generate(
                  4,
                  (index) => GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: MyColor.purpleTranparent,
                                    borderRadius: BorderRadius.circular(8.0)),
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
                            ],
                          ),
                        ),
                      )),
            ),
          )
        ],
      ),
    );
  }
}
