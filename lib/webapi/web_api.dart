import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pet/helper/constant.dart';
import 'package:pet/helper/utils.dart';
import 'package:pet/injection/dependency_injection.dart';
import 'package:pet/model/base_response.dart';
import 'package:pet/model/err_response.dart';
import 'package:pet/model/refresh.dart';

class WebApi {
  static const baseUrl = "https://pbh-app.herokuapp.com/";

  static String rqLogin = "api/token/";
  static String rqRegister = "api/jwtauth/register/";
  static String rqGetEvents = "pets/api/v2/pet_events/";
  static String addPet = "pets/api/v2/pets/";
  static String rqBusinessPhoto = "/business/photo";
  static String rqBusiness = "/business";
  static String rqBusinessMe = "/business/me";
  static String rqProduct = "/product";
  static String rqCategory = "/category";
  static String rqDeleteImage = "/product/photo/";
  static String rqProductUpdate = "/product/update";
  static String terms = "/terms";
  static String privacy = "/privacy/policy";
  static String rating = "/business/ratings";
  static String reviews = "/business/reviews?page=";
  static String reviewReplay = "/business/reply/";
  static String guidelines = "/guidelines";
  static String sendOtp = "/send/otp";
  static String verifyOtp = "/verify/otp";
  static String analytics = "​/analytics";
  static String userProfile = "/user/profile";
  static String rqRefreshToken = "token/refresh/";

  static getRequest(String req, String data) {
    return {'apiRequest': req, 'data': data};
  }

  Dio dio = Dio();

  initDio(String apiReq, int type) {
    var headers;
    String acceptHeader;
    String contentTypeHeader;
    String authorizationHeader = 'Bearer ' + Injector.accessToken;

    if (type == Const.get) {
      print("GET or POST method type 1 api call");
      acceptHeader = 'application/json';
    } else if (type == Const.delete) {
      print("DELETE method type 2 api call");
      acceptHeader = 'application/json';
    } else if (type == Const.put) {
      print("PUT method type 3 api call");
      acceptHeader = 'application/json';
      contentTypeHeader = 'application/json';
    } else if (type == Const.postWithForm) {
      print("post with access token method type 4 api call");
      acceptHeader = 'application/json';
      contentTypeHeader = 'multipart/form-data';
    } else if (type == Const.getReqNotToken) {
      print("GET method type 5 api call");
      acceptHeader = 'application/json';
    } else if (type == Const.post || type == Const.postRefreshToken) {
      print("POST method type 0 api call");
      acceptHeader = 'application/json';
      contentTypeHeader = 'application/json';
//      authorizationHeader = "";
    }

    headers = {
      HttpHeaders.acceptHeader: acceptHeader,
      HttpHeaders.contentTypeHeader: contentTypeHeader,
      HttpHeaders.authorizationHeader: authorizationHeader
    };

    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl + apiReq,
        connectTimeout: 20000,
        receiveTimeout: 3000,
        headers: headers);

    dio.options = options;

    return dio;
  }

  Future<dynamic> callAPI(
    int requestMethod,
    String apiReq,
    Map<String, dynamic> jsonMap,
  ) async {
    initDio(apiReq, requestMethod);
    print("request_" + apiReq);
    print("request_map_  " + jsonMap.toString());
    try {
      var baseResponse;

      if (requestMethod == Const.get || requestMethod == Const.getReqNotToken) {
        await dio.get("").then((response) {
          baseResponse = response.data;
        }).catchError((e) {
          handleException(e, requestMethod, apiReq, jsonMap);
        });
      } else if (requestMethod == Const.delete) {
        await dio.delete("").then((response) {
          baseResponse = response.data;
        }).catchError((e) {
          handleException(e, requestMethod, apiReq, jsonMap);
        });
      } else if (requestMethod == Const.put) {
        await dio.put("", data: jsonMap).then((response) {
          baseResponse = response.data;
        }).catchError((e) async {
          handleException(e, requestMethod, apiReq, jsonMap);
        });
      } else {
        await dio.post("", data: json.encode(jsonMap)).then((response) {
          baseResponse = response.data;
        }).catchError((e) {
          handleException(e, requestMethod, apiReq, jsonMap);
        });
      }

      print(apiReq + "_" + baseResponse.toString());

      return baseResponse;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> refreshToken(
      int num, String apiReq, Map<String, dynamic> jsonMap) async {
    initDio(apiReq, num);
    try {
      await dio.post("", data: json.encode(jsonMap)).then((response) async {
        if (response.statusCode == HttpStatus.ok) {
          RefreshTokenResponse refreshTokenResponse =
              RefreshTokenResponse.fromJson(response.data);

          if (refreshTokenResponse != null) {
            await Injector.updateAuthData(refreshTokenResponse.access);
          }
        }
      }).catchError((e) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(e.response.data);
        Utils.showToast(errorResponse.detail);
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  initDioImg(String apiReq, String token) {
    String acceptHeader = 'application/json';
    String authorizationHeader = 'Bearer ' + Injector.accessToken;
    String contentTypeHeader = 'multipart/form-data';
    print("contentTypeHeader " + acceptHeader);
    print("accessToken " + authorizationHeader);
    var headers = {
      HttpHeaders.acceptHeader: acceptHeader,
      HttpHeaders.authorizationHeader: authorizationHeader,
      HttpHeaders.contentTypeHeader: contentTypeHeader,
    };
    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl + apiReq,
        connectTimeout: 20000,
        receiveTimeout: 3000,
        headers: headers);
    dio.options = options;
    return dio;
  }

  Future<FormData> uploadImage(List<File> file) async {
    FormData formData = new FormData();

    for (int i = 0; i < file.length; i++) {
      String fileName = file[i].path.split('/').last;
      formData = FormData.fromMap({
        "photos[]":
            await MultipartFile.fromFile(file[i].path, filename: fileName),
      });
    }
    return formData;
  }

//  Future<dynamic> uploadImageProduct(
//      String apiReq, AddProductRequest rq, List<File> files) async {
//    initDio(apiReq, Const.postWithAccess);
//
//    FormData formData;
//
//    formData = FormData.fromMap({
//      "product_id": rq.productId,
//      "category": rq.category,
//      "product_name": rq.productName,
//      "description": rq.description,
//      "price": rq.price,
//      "per_quantity": rq.perQuantity
//    });
//
//    for (int i = 0; i < files.length; i++) {
//      String fileName = files[i].path.split('/').last;
//
//      formData.files.add(MapEntry("photos[]",
//          await MultipartFile.fromFile(files[i].path, filename: fileName)));
//    }
//
//    BaseResponse _response;
//    await dio.post("", data: formData).then((response) {
//      _response = BaseResponse.fromJson(response.data);
//    }).catchError((e) {
//      _response = BaseResponse.fromJson(e.response.data);
//      Utils.showToast(_response.message);
//    });
//    print(_response);
//
//    return _response;
//  }

  Future<BaseResponse> editProfile(String apiReq, File files) async {
    initDio(apiReq, Const.postWithAccess);

    FormData formData;
    String fileName = files.path.split('/').last;

    formData = FormData.fromMap({"firstname": "", "lastname": ""});

    formData.files.add(MapEntry("profile",
        await MultipartFile.fromFile(files.path, filename: fileName)));

    BaseResponse _response;
    await dio.post("", data: formData).then((response) {
      _response = BaseResponse.fromJson(response.data);
    }).catchError((e) {
      _response = BaseResponse.fromJson(e.response.data);
      Utils.showToast(_response.message);
    });
    print(_response);

    return _response;
  }

  Future<BaseResponse> uploadImgApi(
      String apiReq, String token, List<File> images) async {
    initDioImg(apiReq, token);
    try {
      var response;

      await uploadImage(images).then((formData) async {
        response = await dio.post("", data: formData).catchError((e) {
          Utils.showToast(apiReq + "_" + e.toString());
          return null;
        });
      });

      print(apiReq + "_" + response?.data.toString());
      if (response.statusCode == 200) {
        BaseResponse _response = BaseResponse.fromJson(response.data);

        if (_response != null) {
          if (_response.success) {
            return _response;
          } else {
            Utils.showToast(_response.message ?? "Please try again later.");
            return null;
          }
        } else {
          Utils.showToast("Please try again later");
          return null;
        }
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  getFiles(List<File> files) async {
    return files.forEach((file) async {
      String fileName = file.path.split('/').last;
      await MultipartFile.fromFile(file.path, filename: fileName);
    });
  }

  Future<BaseResponse> handleException(
      e, int requestMethod, String apiReq, Map<String, dynamic> jsonMap) async {
    BaseResponse baseResponse = BaseResponse.fromJson(e.response.data);

    if (e.response.statusCode == HttpStatus.unauthorized) {
      if (apiReq == WebApi.rqRegister || apiReq == WebApi.rqLogin)
        Utils.showToast(e.response.data['detail']);
      else {
        RefreshTokenRequest rq = RefreshTokenRequest();
        rq.refresh = Injector.signInResponse.refresh;
        var baseResponse =
            await refreshToken(Const.post, WebApi.rqRefreshToken, rq.toJson());
        if (baseResponse != null) {
          initDio(apiReq, requestMethod);
          callAPI(requestMethod, apiReq, jsonMap);
        } else {
          Utils.showToast(baseResponse.message);
        }
      }
    } else if (e.response.statusCode == HttpStatus.badRequest) {
      print(e.response.data);

      if (apiReq == WebApi.rqRegister && e.response.data['username'] != null)
        Utils.showToast(e.response.data['username'][0]);
      else if (apiReq == WebApi.rqRegister && e.response.data['email'] != null)
        Utils.showToast(e.response.data['email']);
      else {
        Utils.showToast("Something went wrong");
      }
    } else if (e.response.statusCode == HttpStatus.unauthorized) {
      print(e.response.data);

      Utils.showToast(e.response.data['detail']);
    }

    return baseResponse;
  }
}
