import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart';
import 'package:majorproject/Profile/user_info.dart';
import 'package:majorproject/model/recommend/dietmodel.dart';
import 'package:majorproject/model/user_food.dart';
import 'package:majorproject/model/recommend/dietmodel.dart';
import 'package:majorproject/model/recommend/exercisemodel.dart';

class api {

  static Authentication(Map<String, String> headers) async{
    final storage = new FlutterSecureStorage();
    String ?token=await storage.read(key: 'token');
    if(token==null){
      return headers;
    }
    if (token != "") {
      token = "Bearer "+token!;

      headers['Authorization'] = token;
    }
    return headers;
  }

  /**
   * URL String
   * Body JSON String
   * Headers array
   */
  static Post(String url, String body) async {
    /*
    Check if logged in
     */
    //write the response of /login to a file
    //read the file and get the token
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    headers=await Authentication(headers);

    Response response = await post(
        Uri.parse(url),
        headers: headers,
        body: body
    );
    print(response.body);
    return (response);
  }

  static Put(String url, String body) async {
    /*
    Check if logged in
     */
    //write the response of /login to a file
    //read the file and get the token
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    headers=await Authentication(headers);

    Response response = await put(
        Uri.parse(url),
        headers: headers,
        body: body
    );
    print(response.body);
    // print(response.body);
    return (response);
  }

  /**
   * URL String
   * Body JSON String
   * Headers array
   */
  static Get(String url) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    headers=await Authentication(headers);
    Response response = await get(
      Uri.parse(url),
      headers: headers,
    );
    return response;
  }

  Future<List<FoodPost>> GetFood(String url)
  async {
     Response response = await Get(url);
     if(response.statusCode == 200)
       {
         List<dynamic> body=jsonDecode(response.body);

         List<FoodPost> posts= body
             .map(
             (dynamic item)=>FoodPost.fromJson(item),
         ).toList();
         return posts;
       }
        else{
          throw "Unable to retrieve post";
     }
  }

  // Future<Response> PostFood(String url, Map<String, dynamic> requestBody) async {
  //   try {
  //     // Make a POST request to the specified URL with the request body
  //     Response response = await post(Uri.parse(url), body: requestBody);
  //     return response;
  //   } catch (error) {
  //     // Handle any errors that occur during the request
  //     throw "Error posting food to log: $error";
  //   }
  // }

  Future<List<InfoPosts>> Getufeature(String url)
  async {
    Response response = await Get(url);

    if(response.statusCode == 200)
    {
      List<dynamic> body=jsonDecode(response.body);

      List<InfoPosts> posts= body
          .map(
            (dynamic item)=>InfoPosts.fromJson(item),
      ).toList();
      return posts;

    }

    else{
      throw "Unable to retrieve data";
    }
  }


  Future<List<RecFood>> GetRecommend(String url)
  async {
    Response response = await Get(url);
    print(response);
    if(response.statusCode == 200)
    {
      List<dynamic> body=jsonDecode(response.body);

      List<RecFood> posts= body
          .map(
            (dynamic item)=>RecFood.fromJson(item),
      ).toList();
      return posts;
    }
    else{
      throw "Unable to retrieve post";
    }
  }


  Future<List<ExercisePost>> GetExercise(String url)
  async {
    Response response = await Get(url);
    if(response.statusCode == 200)
    {
      try {
        // Decode JSON
        List<dynamic> body = jsonDecode(response.body);

        // Parse the JSON and proceed
        List<ExercisePost> posts = body.map((dynamic item) => ExercisePost.fromJson(item)).toList();
        return posts;
      } catch (e) {
        print('Error decoding JSON: $e');
        // Handle the error gracefully, e.g., return an empty list or throw an exception
        return [];
      }
      catch (e) {
        print('Error decoding JSON: $e');
        // Handle the error gracefully, e.g., return an empty list or throw an exception
        return [];
      }
    }
    else{
      throw "Unable to retrieve post";
    }
  }


}
