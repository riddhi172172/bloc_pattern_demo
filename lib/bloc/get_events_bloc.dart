
import 'package:pet/helper/constant.dart';
import 'package:pet/helper/utils.dart';
import 'package:pet/model/get_event.dart';
import 'package:pet/webapi/web_api.dart';
import 'package:rxdart/rxdart.dart';

final getEventBloc = GetEventsBloc();

class GetEventsBloc {
  final _getEventSubject = PublishSubject<List<PetEvent>>();

  Observable<List<PetEvent>> get getEventsOb => _getEventSubject.stream;

  getEvents() async {
    bool isInternetConnected = await Utils.isInternetConnected();
    List<PetEvent> arrQuestions = List();
    if (isInternetConnected) {
      dynamic data =
          await WebApi().callAPI(Const.get, WebApi.rqGetEvents,{});

      GetEventResponse getEventResponse = GetEventResponse.fromJson(data);

      arrQuestions = getEventResponse.results;
      _getEventSubject.sink.add(arrQuestions);
    }
  }

  updateQuestions(List<PetEvent> arrQuestions) async {
    _getEventSubject.sink.add(arrQuestions);
  }

  dispose() {
    _getEventSubject.close();
  }
}
