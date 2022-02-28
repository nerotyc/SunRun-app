
// static Future<Run> runDetail(int id) async {
//   var token = "";
//   // var token = MyHomePageState.accessToken;
//
//   // https://stackoverflow.com/questions/57369129/flutter-http-post-request-error-invalid-media-type-expected
//   Map<String, String> headers = {
//     "content-type": "application/json",
//     HttpHeaders.authorizationHeader: "Token " + token,
//   };
//   Map<String, String> queryParameters = {
//     // "Some": "Parameter"
//   };
//
//   // String url = 'https://stackoverflow.com/questions/57369129/flutter-http-post-request-error-invalid-media-type-expected/';
//   String url = 'http://run.djk-sonnen.de/api/v1/run/detail/' + id.toString() + '/';
//   String payloadAsString = ""; // {\"foo\":\"bar\"}
//   http.Response response;
//   try {
//     response = await HttpUtils.getForFullResponse(url,
//         queryParameters: queryParameters, headers: headers);
//   } catch (e) {
//     // Handle exception, for example if response status code != 200-299
//   }
//   print(response.body);
//
//   // final response = await http.get(
//   //   Uri.parse('http://run.djk-sonnen.de/api/v1/run/detail/' + id.toString() + '/'),
//   //   headers: {
//   //     HttpHeaders.authorizationHeader: "Token " + token,
//   //     HttpHeaders.contentTypeHeader: "Content-type: application/json; charset=utf-8",
//   //     HttpHeaders.acceptHeader: "application/json; charset=utf-8",
//   //   },
//   // );
//   //
//   // print("reponse: " + response.body.toString());
//
//   if (response.statusCode == 200) {
//     print("run received!");
//     final responseJson = jsonDecode(response.body);
//
//     try {
//       Run run = Run.fromJson(responseJson);
//       if(run != null) return run;
//     } on Exception catch(e) {
//       print("Error: " + e.toString());
//     }
//
//   } else {
//     final responseJson = jsonDecode(response.body);
//     print("Error occurred: ");
//     int code = responseJson['code'];
//     String errorMsg = responseJson['error'];
//     print(code.toString() + ": " + errorMsg.toString());
//   }
// }