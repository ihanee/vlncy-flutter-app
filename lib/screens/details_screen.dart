import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vlncy/components/default_button.dart';
import 'package:vlncy/utils/colors.dart';

import 'package:vlncy/utils/size_config.dart';

import '../components/radar_chart.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatefulWidget {
  Map<String, dynamic> data;
  final String distance;
  DetailsScreen({
    super.key,
    required this.data,
    required this.distance,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool darkMode = false;
  bool useSides = false;
  static const ticks = [7, 14, 21, 28, 35];
  var features = [
    "FT1",
    "Experimental",
    "Inspiring",
    "Sound",
    "Insightful",
    "Stabilising",
  ];
  var data = [
    [
      10.0,
      20,
      28,
      5,
      16,
      15,
    ],
    [
      14.5,
      1,
      4,
      14,
      23,
      10,
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(10),
            vertical: getProportionateScreenHeight(35)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    CupertinoIcons.back,
                    size: getProportionateScreenWidth(25),
                    color: white.withOpacity(0.4),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                Center(
                  child: Text(
                    widget.data["user_id"].toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(20),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(6),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.data["user_age"].toString()} years old",
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                        fontSize: getProportionateScreenWidth(14),
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(6),
                    ),
                    Text(
                      "|",
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                        fontSize: getProportionateScreenWidth(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(6),
                    ),
                    Text(
                      "${widget.distance}s away",
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                        fontSize: getProportionateScreenWidth(14),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),
                Center(
                  child: Text(
                    "Hers's how well you vibe together",
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.5),
                      fontSize: getProportionateScreenWidth(18),
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: getProportionateScreenHeight(20),
                          width: getProportionateScreenWidth(20),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(
                                  getProportionateScreenWidth(5))),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                        Text(
                          "You",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: getProportionateScreenWidth(16),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(30),
                    ),
                    Row(
                      children: [
                        Container(
                          height: getProportionateScreenHeight(20),
                          width: getProportionateScreenWidth(20),
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(
                                  getProportionateScreenWidth(5))),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                        Text(
                          "Match",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: getProportionateScreenWidth(16),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(40),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: getProportionateScreenWidth(20)),
                  height: getProportionateScreenHeight(280),
                  width: getProportionateScreenWidth(280),
                  child: RadarChart.dark(
                    ticks: ticks,
                    features: features,
                    data: data,
                    reverseAxis: true,
                    useSides: true,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(24)),
              child: DefaultButton(
                  text: "Initiate bonding", press: () {}, color: white),
            )
          ],
        ),
      )),
    );
  }
}
