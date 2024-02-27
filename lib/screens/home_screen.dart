import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radar_chart/radar_chart.dart';
import 'package:vlncy/screens/details_screen.dart';
import 'package:vlncy/services/distance_matrix_services.dart';
import 'package:vlncy/services/users_services.dart';
import 'package:vlncy/utils/colors.dart';
import 'package:vlncy/utils/size_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> users = [];
  double maxDistance = 30;
  double minAge = 18;
  double maxAge = 50;
  String? selectedUserId;
  List<double> values1 = [
    0.55,
    0.84,
    0.8,
    0.85,
    0.55,
    0.95,
  ];
  var filteredMatches = [];
  Map<String, dynamic> mainUser = {};
  bool isLoading = false;

  CalculateDistanceService calculateDistanceService =
      CalculateDistanceService();
  UsersServices usersServices = UsersServices();

  showModalSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(20)),
              color: Colors.black87,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distance Limit: ${mainUser["pref_distance"][1].toStringAsFixed(1)} kms',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                      color: Colors.white,
                    ),
                  ),
                  Slider(
                    value: mainUser["pref_distance"][1].toDouble(),
                    min: 0,
                    max: 50,
                    divisions: 50,
                    label: mainUser["pref_distance"][1].toStringAsFixed(1),
                    onChanged: (value) {
                      // setState(() {
                      //   maxDistance = value;
                      // });
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Text(
                    'Age Limit: ${mainUser["pref_age"][0]} - ${mainUser["pref_age"][1]} years',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                      color: Colors.white,
                    ),
                  ),
                  RangeSlider(
                    values: RangeValues(mainUser['pref_age'][0].toDouble(),
                        mainUser['pref_age'][1].toDouble()),
                    min: 18,
                    max: 60,
                    divisions: 82,
                    labels: RangeLabels(
                      mainUser['pref_age'][0].toString(),
                      mainUser['pref_age'][1].toString(),
                    ),
                    onChanged: (RangeValues values) {
                      // setState(() {
                      //   minAge = values.start;
                      //   maxAge = values.end;
                      // });
                    },
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  getFilteredData() {
    mainUser = users.firstWhere((user) => user['user_id'] == selectedUserId);
    filteredMatches = mainUser['user_matches'].entries.where((entry) {
      final matchedUser =
          users.firstWhere((user) => user['user_id'] == entry.key);
      return matchedUser['pref_distance'][1] <= maxDistance &&
          matchedUser['user_age'] >= minAge &&
          matchedUser['user_age'] <= maxAge;
    }).toList();
    setState(() {});
  }

  getDistance(origin, destination) async {
    final distance =
        await calculateDistanceService.getDistance(origin, destination);
    return distance;
  }

  Future getUsers() async {
    setState(() {
      isLoading = true;
    });

    final results = await usersServices.getUsers();
    if (results != null) {
      users = results.cast<Map<String, dynamic>>(); // Explicit casting
      selectedUserId = users.isNotEmpty ? users.first['user_id'] : '';
      mainUser = users.first;
      getFilteredData();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Text(
          "Loading, please wait...",
          style: TextStyle(
              color: fontcolor, fontSize: getProportionateScreenWidth(16)),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(16),
            right: getProportionateScreenWidth(16),
            top: getProportionateScreenHeight(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "vlncy",
                    style: TextStyle(
                        color: white,
                        fontSize: getProportionateScreenWidth(24),
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalSheet();
                    },
                    child: Transform.rotate(
                      angle: -55,
                      child: Icon(
                        CupertinoIcons.slider_horizontal_3,
                        textDirection: TextDirection.ltr,
                        size: getProportionateScreenWidth(25),
                        color: fontcolor.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(55)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome ',
                    style: TextStyle(
                      color: fontcolor,
                      fontSize: getProportionateScreenWidth(28),
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedUserId,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUserId = newValue!;
                        mainUser = users.firstWhere(
                            (user) => user['user_id'] == selectedUserId);
                        getFilteredData();
                      });
                    },
                    underline: Container(),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    items: users.map<DropdownMenuItem<String>>(
                      (Map<String, dynamic> user) {
                        return DropdownMenuItem(
                          value: user['user_id'],
                          child: Container(
                            color: Colors.black,
                            child: Text(
                              user['user_id'],
                              style: TextStyle(
                                color: white,
                                fontSize: getProportionateScreenWidth(22),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  )
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                "Top recommendations for you",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: fontcolor,
                  fontSize: getProportionateScreenWidth(18),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: Future.wait(filteredMatches
                      .map((match) => getDistance(
                              mainUser['user_zip'],
                              users.firstWhere((user) =>
                                  user['user_id'] == match.key)['user_zip'])
                          as Future<dynamic>)
                      .toList()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return ListView.builder(
                        itemCount: filteredMatches.length,
                        itemBuilder: (context, index) {
                          final match = filteredMatches[index];
                          final matchedUser = users.firstWhere(
                              (user) => user['user_id'] == match.key);
                          final distance = snapshot.data?[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                      data: matchedUser, distance: distance)));
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: getProportionateScreenHeight(10),
                                bottom: getProportionateScreenHeight(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(16),
                                vertical: getProportionateScreenHeight(12),
                              ),
                              decoration: BoxDecoration(
                                color: grey.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(
                                  getProportionateScreenWidth(9),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${matchedUser['user_id']}",
                                        style: TextStyle(
                                          color: white,
                                          fontSize:
                                              getProportionateScreenWidth(14),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(10),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${matchedUser['user_age']} years old",
                                            style: TextStyle(
                                              color: fontcolor,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      14),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                getProportionateScreenWidth(6),
                                          ),
                                          Text(
                                            "|",
                                            style: TextStyle(
                                              color: fontcolor,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      14),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                getProportionateScreenWidth(6),
                                          ),
                                          Text(
                                            "${distance}s away",
                                            style: TextStyle(
                                              color: fontcolor,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      14),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(10),
                                      ),
                                      Icon(
                                        CupertinoIcons.eye_slash,
                                        size: getProportionateScreenWidth(18),
                                        color: fontcolor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 100, // or specify a fixed width
                                    height: 100, // or specify a fixed height
                                    child: RadarChart(
                                      length: values1.length,
                                      radius: getProportionateScreenWidth(50),
                                      initialAngle: pi / 3,
                                      radialStroke: 2,
                                      radialColor: Colors.transparent,
                                      radars: [
                                        RadarTile(
                                          values: values1,
                                          borderStroke: 2,
                                          borderColor: Colors.yellow,
                                          backgroundColor:
                                              const Color(0xff373737)
                                                  .withOpacity(0.7),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
