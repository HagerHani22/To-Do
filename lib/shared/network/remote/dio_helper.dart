import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(
      BaseOptions(
        // baseUrl: 'https://newsapi.org/',                            //newsProject
        baseUrl: 'https://student.valuxapps.com/api/',                //shopProject
        // baseUrl: 'http://milanoex-app.milano-eg.com:5000/api/',   //milanoProject
        receiveDataWhenStatusError: true,
      ),
    );
  }

 static Future<Response> getData({
    required String url,
    Map<String,dynamic> ?query,
    String lang='en',
    String ?token,
  })async
  {
    dio.options.headers=
    {
      'lang':lang,
      'Content-Type':'application/json',
      'Authorization':token??'',
    };
 return await dio.get(url,queryParameters: query??null);
  }

  static Future<Response>postData({
    required String url,
    Map<String,dynamic>? query,
    required Map <String,dynamic> data,
    String lang='en',
    String ?token,
}) async
  {
    dio.options.headers=
       {
         'lang':lang,
         'Authorization':token??'',
         'Content-Type':'application/json',

         ///////////milanoHeader

         // 'Content-Type':'application/json',
         // 'accept':'application/json',
         // 'tenant':'root',

       };
    return await dio.post(url,queryParameters: query??null,data: data);
  }


  static Future<Response>putData({
    required String url,
    Map<String,dynamic>? query,
    required Map <String,dynamic> data,
    String lang='en',
    String ?token,
}) async
  {
    dio.options.headers=
       {
         'lang':lang,
         'Authorization':token??'',
         'Content-Type':'application/json',

         ///////////milanoHeader

         // 'Content-Type':'application/json',
         // 'accept':'application/json',
         // 'tenant':'root',

       };
    return await dio.put(url,queryParameters: query??null,data: data);
  }



}

