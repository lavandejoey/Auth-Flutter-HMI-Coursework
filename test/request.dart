import 'package:hmi/user.dart';
import 'package:test/test.dart';
import "package:hmi/database.dart";

void main() {
  group('UserDb', () {
    test('User DB APIs Test', () async {
      // Create an instance of UserDb
      final userDb = UserDb();
      // extract the user count as int
      final User? rst = await userDb.getUser(uid: "Joshua");
      if (rst != null) {
        print(rst.username);
      }
    });
  });
}
