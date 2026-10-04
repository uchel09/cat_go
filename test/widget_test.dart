import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:cat_go/app/data/local/app_database.dart';
import 'package:cat_go/app/data/repositories/content_repository.dart';
import 'package:cat_go/app/data/repositories/content_repository_drift.dart';
import 'package:cat_go/app/data/repositories/exam_repository.dart';
import 'package:cat_go/app/data/repositories/exam_repository_drift.dart';
import 'package:cat_go/app/modules/home/controllers/home_controller.dart';
import 'package:cat_go/app/modules/home/views/home_view.dart';

void main() {
  testWidgets('HomeView renders properly', (WidgetTester tester) async {
    Get.reset();
    final db = AppDatabase(NativeDatabase.memory());
    final contentRepo = ContentRepositoryDrift(db);
    final examRepo = ExamRepositoryDrift(db);
    Get.put<AppDatabase>(db);
    Get.put<ContentRepository>(contentRepo);
    Get.put<ExamRepository>(examRepo);

    Get.put(HomeController(autoInitBundledPacks: false));
    await tester.pumpWidget(const GetMaterialApp(home: HomeView()));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('CAT Go'), findsOneWidget);
    await db.close();
  });
}
