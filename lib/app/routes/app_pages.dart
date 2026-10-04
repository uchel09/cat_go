import 'package:get/get.dart';

import '../modules/exam/bindings/exam_binding.dart';
import '../modules/exam/views/exam_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/packs/bindings/packs_binding.dart';
import '../modules/packs/views/packs_view.dart';
import '../modules/result/bindings/result_binding.dart';
import '../modules/result/views/result_view.dart';
import '../modules/review/bindings/review_binding.dart';
import '../modules/review/views/review_view.dart';
import '../modules/subtes/bindings/subtes_binding.dart';
import '../modules/subtes/views/subtes_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SUBTES,
      page: () => const SubtesView(),
      binding: SubtesBinding(),
    ),
    GetPage(
      name: _Paths.EXAM,
      page: () => const ExamView(),
      binding: ExamBinding(),
    ),
    GetPage(
      name: _Paths.RESULT,
      page: () => const ResultView(),
      binding: ResultBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW,
      page: () => const ReviewView(),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: _Paths.PACKS,
      page: () => const PacksView(),
      binding: PacksBinding(),
    ),
  ];
}
