import 'package:dio/dio.dart';

class DioHelper{
  static Dio? dio ;

  static init(){
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
            receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
  required url ,
     Map<String , dynamic>? query,
    String lang = 'en',
    String? token ,
  })async
  {
    dio!.options.headers ={
        'Content-Type' : 'application/json',
        'lang' : lang,
        'Authorization' : token??'',
      };
    return await dio!.get(
        url,
      queryParameters: query,
    );
}

static Future<Response> postData({
  required url ,
  Map<String , dynamic>? query,
  required Map<String , dynamic>? data,
  String lang = 'en',
  String? token ,
})async
{
  dio!.options.headers ={
        'Content-Type' : 'application/json',
        'lang' : lang,
        'Authorization' : token??'',
  };
    return dio!.post(
      url ,
      queryParameters: query ,
      data: data
    );
}

  static Future<Response> putData({
    required url ,
    Map<String , dynamic>? query,
    required Map<String , dynamic>? data,
    String lang = 'en',
    String? token ,
  })async
  {
    dio!.options.headers ={
      'Content-Type' : 'application/json',
      'lang' : lang,
      'Authorization' : token??'',
    };
    return dio!.put(
        url ,
        queryParameters: query ,
        data: data
    );
  }

}