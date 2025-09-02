import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movie_mate_app/core/constants/hive_box_names.dart';

class HiveService {

  final Box<Map> userBox = Hive.box(HiveBoxNames.users);
  final Box<Map> savedMoviesBox = Hive.box(HiveBoxNames.savedMovies);
  final Box<Map> nowPlayingMoviesBox = Hive.box(HiveBoxNames.nowPlayingMovies);


  static Future<void> openBoxes() async {
    await Hive.openBox<Map>(HiveBoxNames.users);
    await Hive.openBox<Map>(HiveBoxNames.savedMovies);
    await Hive.openBox<Map>(HiveBoxNames.nowPlayingMovies);
  }
}

final hiveServiceProvider = Provider<HiveService>((_) => HiveService());