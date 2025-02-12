import 'package:bloc/bloc.dart';
import 'package:expense_tracker_app/app.dart';
import 'package:expense_tracker_app/simpleBlocObserver.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}
