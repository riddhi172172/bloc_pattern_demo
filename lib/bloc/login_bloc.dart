import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

final localeBloc = LocaleBloc();

class LocaleBloc {
  final _assignLocaleSubject = PublishSubject<Locale>();

  Observable<Locale> get locale => _assignLocaleSubject.stream;

  setLocale(int index) async {
    _assignLocaleSubject.sink.add(Locale('en', ''));
    return _assignLocaleSubject.stream.distinct();
  }

  dispose() {
    _assignLocaleSubject.close();
  }
}
