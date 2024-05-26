import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:majorproject/Profile/profile.dart';
import 'package:majorproject/Profile/user_info.dart';
import 'package:majorproject/service/api.dart';
import '../../third.dart';
import 'dietmodel.dart';

class GetDietRec extends StatelessWidget {

  final api apis = api();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[200],
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(LineAwesomeIcons.angle_left)),
            title: Text('Food Recommendations'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Breakfast'),
                Tab(text: 'Lunch'),
                Tab(text: 'Dinner'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FoodRecommendations(
                type: 'breakfast',
                // Pass callback to FoodRecommendations
                onFoodSelected: (foodItem) {
                  _addToLog(context, foodItem);
                },
              ),
              FoodRecommendations(
                type: 'lunch',
                onFoodSelected: (foodItem) {
                  _addToLog(context, foodItem);
                },
              ),
              FoodRecommendations(
                type: 'dinner',
                onFoodSelected: (foodItem) {
                  _addToLog(context, foodItem);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Callback function to add selected food to the log
  void _addToLog(BuildContext context, RecFood food) async {
    // Define requestBody with the necessary data
    Map<String, dynamic> requestBody = {
      'name': food.name,
      "calorie":"200",
      "description":"",
      "count":"",
      // 'calories': food.calories,
      'date': '2024-03-07',
    };

    // Encode requestBody to JSON string
    String requestBodyJson = jsonEncode(requestBody);

    // Make the POST request to add the food to the log
    try {
      Response response = await api.Post('http://major.dns.army/api/food', requestBodyJson);

      if (response.statusCode == 200) {
        // Food successfully added to the log
        print('Food added to log successfully: ${food.name}');
        // Show a dialog to indicate the food item is added
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("${food.name} added to log"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
    //
    // // Encode requestBody to JSON string
    // String requestBodyJson = jsonEncode(requestBody);
    //
    // // Make the POST request to add the food to the log
    // try {
    //   Response response = await api.Post('http://major.dns.army/api/food', requestBodyJson);
    //
    //   if (response.statusCode == 200) {
    //     // Food successfully added to the log
    //     print('Food added to log successfully: ${food.name}');
      } else {
        // Error occurred while adding the food to the log
        print('Failed to add food to log: ${response.body}');
        // You can handle the error appropriately
      }
    } catch (error) {
      // An error occurred while making the request
      print('Error adding food to log: $error');
      // You can handle the error appropriately
    }

    // Show a snackbar to indicate the food item is added
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('${food.name} added to log')),
    // );
  }
  }


class FoodRecommendations extends StatelessWidget {
  final String type;
  final Function(RecFood) onFoodSelected; // Callback function

  final api apis = api();

  FoodRecommendations({required this.type, required this.onFoodSelected});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecFood>>(
      future: apis.GetRecommend("http://major.dns.army/api/why"),
      builder: (context, AsyncSnapshot<List<RecFood>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final List<RecFood> recommendations = snapshot.data!;
          final List<RecFood> filteredRecommendations = recommendations
              .where((food) => food.type.toLowerCase() == type.toLowerCase())
              .toList();
          if (filteredRecommendations.isNotEmpty) {
            return ListView.builder(
              itemCount: filteredRecommendations.length,
              itemBuilder: (context, index) {
                final RecFood item = filteredRecommendations[index];
                return ListTile(
                  onTap: () =>
                    // Call the callback function when the food is tapped
                    onFoodSelected(item),
                  title: Text(item.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Calories: ${item.calories}'),
                      Text('SodiumContent: ${item.sodiumContent} mg'),
                      Text('SugarContent: ${item.sugarContent} g'),
                      Text('CarbohydrateContent: ${item.carbohydrateContent} g'),
                      Text('Type: ${item.type}'),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No ${type} recommendations available'));
          }
        } else {
          return Center(child: Text('No recommendations available'));
        }
      },
    );
  }
}

// class GetDietRec extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.blue[200],
//             leading: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: Icon(LineAwesomeIcons.angle_left)),
//             title: Text('Food Recommendations'),
//             bottom: TabBar(
//               tabs: [
//                 Tab(text: 'Breakfast'),
//                 Tab(text: 'Lunch'),
//                 Tab(text: 'Dinner'),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: [
//               FoodRecommendations(type: 'breakfast'),
//               FoodRecommendations(type: 'lunch'),
//               FoodRecommendations(type: 'dinner'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FoodRecommendations extends StatelessWidget {
//   final String type;
//   final api apis = api();
//
//   FoodRecommendations({required this.type});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<RecFood>>(
//       future: apis.GetRecommend("http://major.dns.army/api/why"),
//       builder: (context, AsyncSnapshot<List<RecFood>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (snapshot.hasData) {
//           final List<RecFood> recommendations = snapshot.data!;
//           final List<RecFood> filteredRecommendations = recommendations
//               .where((food) => food.type.toLowerCase() == type.toLowerCase())
//               .toList();
//           if (filteredRecommendations.isNotEmpty) {
//             return ListView.builder(
//               itemCount: filteredRecommendations.length,
//               itemBuilder: (context, index) {
//                 final RecFood item = filteredRecommendations[index];
//                 return ListTile(
//                   title: Text(item.name),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Calories: ${item.calories}'),
//                       Text('SodiumContent: ${item.sodiumContent} mg'),
//                       Text('SugarContent: ${item.sugarContent} g'),
//                       Text('CarbohydrateContent: ${item.carbohydrateContent} g'),
//                       Text('Type: ${item.type}'),
//                     ],
//                   ),
//                 );
//               },
//             );
//           } else {
//             return Center(child: Text('No ${type} recommendations available'));
//           }
//         } else {
//           return Center(child: Text('No recommendations available'));
//         }
//       },
//     );
//   }
// }


// class GetDietRec extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           appBar: AppBar( backgroundColor: Colors.blue[200],
//             leading: IconButton(
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => const MyTabBar()));
//                 },
//                 icon: const Icon(LineAwesomeIcons.angle_left)),
//             title: Text('Food Recommendations'),
//
//             bottom: TabBar(
//               tabs: [
//                 Tab(text: 'Breakfast'),
//                 Tab(text: 'Lunch'),
//                 Tab(text: 'Dinner'),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: [
//               FoodRecommendations(type: 'breakfast'),
//               FoodRecommendations(type: 'lunch'),
//               FoodRecommendations(type: 'dinner'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FoodRecommendations extends StatelessWidget {
//   final String type;
//   final api apis=api();
//
//   FoodRecommendations({Key? key, required this.type}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: apis.GetRecommend("http://major.dns.army/api/why"),
//       builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (snapshot.hasData) {
//           final recommendations = snapshot.data!;
//           return ListView.builder(
//             itemCount: recommendations.length,
//             itemBuilder: (context, index) {
//               final RecFood item = recommendations[index];
//               return ListTile(
//                 title: Text(item.name),
//                   subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Calories: ${item.calories}'),
//                         Text('SodiumContent: ${item.sodiumContent}'),
//                         Text('SugarContent: ${item.sugarContent}'),
//                         Text('CarbohydrateContent: ${item.carbohydrateContent}'),
//                         Text('Type: ${item.type}'),
//                       ]
//                   ));
//                 // subtitle: Text('Calories: ${item.calories}')
//               // );
//             },
//           );
//         } else {
//           return Text('No recommendations available');
//         }
//       },
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => const MyTabBar()));
//                 },
//                 icon: const Icon(LineAwesomeIcons.angle_left)),
//             title: Text('Food Recommendations'),
//             bottom: TabBar(
//               tabs: [
//                 Tab(text: 'Breakfast'),
//                 Tab(text: 'Lunch'),
//                 Tab(text: 'Dinner'),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: [
//               FoodRecommendations(type: 'breakfast'),
//               FoodRecommendations(type: 'lunch'),
//               FoodRecommendations(type: 'dinner'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FoodRecommendations extends StatelessWidget {
//   final String type;
//
//   // Example data, replace with your actual data source
//   final Map<String, List<Map<String, dynamic>>> recommendations = {
//     'breakfast': [
//       {'Name': 'Walnut Pear Cinnamon Coffee Cake', 'Calories': 611.3, 'SodiumContent':346.4, 'SugarContent':52.8 },
//       {'Name': 'Yummy Banana Bread', 'Calories': 716.9, 'SodiumContent':339.9, 'SugarContent':35.8},
//       {'Name': 'Hearty Breakfast', 'Calories': 717.0, 'SodiumContent':1013.0, 'SugarContent':3.2},
//     ],
//     'lunch': [
//       {'Name': 'Sequilhos de coco(Coconut and Cornstarch Cookies)', 'Calories': 687.3, 'SodiumContent':387.0, 'SugarContent':39.4},
//       {'Name': 'Mushroom-Almond Tart', 'Calories': 630.0, 'SodiumContent':400.3,'SugarContent':2.4},
//       {'Name': 'Maple Granola', 'Calories': 611.0, 'SodiumContent':70.5,'SugarContent':18.9},
//     ],
//     'dinner': [
//       {'Name': 'Granny Lil\'s Spinach Salad', 'Calories': 674.4,'SodiumContent':937.0,'SugarContent':19.8},
//       {'Name': 'Breaded Catfish With Mushroom Sauce', 'Calories': 707.9,'SodiumContent':425.5,'SugarContent':4.7},
//       {'Name': 'Salted Caramel Brownies	', 'Calories': 733.9,'SodiumContent':337.8,'SugarContent':106.8},
//     ],
//   };
//
//   FoodRecommendations({Key? key, required this.type}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> currentRecommendations = recommendations[type]!;
//
//     return ListView.builder(
//       itemCount: currentRecommendations.length,
//       itemBuilder: (context, index) {
//         final item = currentRecommendations[index];
//         return ListTile(
//           title: Text(item['Name']),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//         Text('Calories: ${item['Calories']}'),
//         Text('SodiumContent: ${item['SodiumContent']}'),
//               Text('SugarContent: ${item['SugarContent']}'),
//           ]
//         ));
//       },
//     );
//   }
// }