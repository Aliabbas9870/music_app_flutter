import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicplay/features/auth/model/user_model.dart';
import 'package:musicplay/features/auth/viewmodel/database_helper.dart';

final dbProvider = Provider<DatabaseHelper>((ref) => DatabaseHelper());
final authProvider = StateProvider<UserModel?>((ref) => null);

class AuthController {
  final Ref ref;
  AuthController({required this.ref});

  Future<bool> signup(String name, String email, String password) async {
    final db = ref.read(dbProvider);
    try {
      final user = UserModel(email: email, name: name, password: password);
      await db.insertUser(user);
      ref.read(authProvider.notifier).state = user;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }


    Future<bool> login(String email, String password,String name) async {
    final db = ref.read(dbProvider);
    final user = await db.getUser(email, password,name);
    if (user != null) {
      ref.read(authProvider.notifier).state = user;
      return true;
    }
    return false;
  }

  void logout() {
    ref.read(authProvider.notifier).state = null;
  }
}


final authControlProvider=Provider<AuthController>((ref)=>AuthController(ref: ref));