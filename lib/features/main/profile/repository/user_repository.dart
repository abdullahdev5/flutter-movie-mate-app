import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/core/model/user_model.dart';
import 'package:movie_mate_app/core/service/hive_service.dart';

class UserRepository {
  UserRepository(this._hiveService);

  final HiveService _hiveService;


  UserModel? getUser(String uid) {
    final userMap = _hiveService.userBox.get(uid);
    debugPrint('User Map: $userMap');
    if (userMap != null) {
      return UserModel.fromMap(Map<String, dynamic>.from(userMap));
    } else {
      return null;
    }
  }

  Future<void> updateUser(UserModel user) async {
    final userMap = user.toMap();
    await _hiveService.userBox.put(user.uid, userMap);
  }



}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.read(hiveServiceProvider));
});