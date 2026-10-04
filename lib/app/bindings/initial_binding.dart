import 'package:get/get.dart';

import '../data/local/app_database.dart';
import '../data/repositories/content_repository.dart';
import '../data/repositories/content_repository_drift.dart';
import '../data/repositories/exam_repository.dart';
import '../data/repositories/exam_repository_drift.dart';
import '../data/services/asset_pack_service.dart';
import '../data/services/catalog_service.dart';
import '../data/services/file_picker_service.dart';
import '../data/services/pack_importer.dart';
import '../data/services/pack_validator.dart';

/// Binding awal aplikasi untuk mendaftarkan database, repository, dan layanan impor.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final database = Get.put<AppDatabase>(AppDatabase(), permanent: true);
    Get.put<ContentRepository>(
      ContentRepositoryDrift(database),
      permanent: true,
    );
    Get.put<ExamRepository>(ExamRepositoryDrift(database), permanent: true);

    final validator = Get.put<PackValidator>(PackValidator(), permanent: true);
    final importer = Get.put<PackImporter>(
      PackImporter(database, validator: validator),
      permanent: true,
    );
    Get.put<AssetPackService>(AssetPackService(importer), permanent: true);
    Get.put<FilePickerService>(FilePickerService(), permanent: true);
    Get.put<CatalogService>(CatalogService(), permanent: true);
  }
}
