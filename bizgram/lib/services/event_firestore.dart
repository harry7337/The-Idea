import 'package:huegahsample/models/app_event.dart';
import 'package:huegahsample/shared/data_constants.dart';
import 'package:firebase_helpers/firebase_helpers.dart';

final eventDBS = DatabaseService<AppEvent>(
  AppDBConstants.eventsCollection,
  fromDS: (id, data) => AppEvent.fromDS(id, data),
  toMap: (event) => event.toMap(),
);
