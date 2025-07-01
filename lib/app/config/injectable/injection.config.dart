// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:instance_a/app/core/services/database/app_db.dart' as _i650;
import 'package:instance_a/app/core/services/database/local/hive_db_impl.dart'
    as _i775;
import 'package:instance_a/app/core/services/sync/repository/generic_sync_repository.dart'
    as _i268;
import 'package:instance_a/app/core/services/sync/scheduler/sync_scheduler.dart'
    as _i106;
import 'package:instance_a/app/core/services/sync/service/sync_service.dart'
    as _i430;
import 'package:instance_a/app/core/services/sync/service/sync_watcher_service.dart'
    as _i393;
import 'package:instance_a/app/core/services/sync/ui/cubit/sync_status_cubit.dart'
    as _i951;
import 'package:instance_a/app/core/utils/connectivity_helper.dart' as _i188;
import 'package:instance_a/app/core/utils/image_picker_utils.dart' as _i723;
import 'package:instance_a/app/features/medicine/adapter/medicine_sync_adapter.dart'
    as _i608;
import 'package:instance_a/app/features/medicine/data/repository/medicine_repository.dart'
    as _i594;
import 'package:instance_a/app/features/medicine/service/medicine_service.dart'
    as _i488;
import 'package:instance_a/app/features/medicine/ui/cubit/medicine_cubit.dart'
    as _i480;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i488.MedicineService>(() => _i488.MedicineService());
  gh.singleton<_i188.ConnectivityHelper>(() => _i188.ConnectivityHelper());
  gh.singleton<_i393.SyncWatcherService>(() => _i393.SyncWatcherService());
  gh.lazySingleton<_i723.ImagePickerUtils>(() => _i723.ImagePickerUtils());
  gh.lazySingleton<_i951.SyncStatusCubit>(() => _i951.SyncStatusCubit());
  gh.lazySingleton<_i608.MedicineSyncAdapter>(
      () => _i608.MedicineSyncAdapter());
  gh.lazySingleton<_i430.SyncService>(
      () => _i430.SyncService(gh<_i188.ConnectivityHelper>()));
  gh.lazySingleton<_i650.AppDb>(() => _i775.HiveDbImpl());
  gh.lazySingleton<_i268.GenericSyncRepository<dynamic>>(
      () => _i268.GenericSyncRepository<dynamic>(
            gh<_i650.AppDb>(),
            gh<_i430.SyncService>(),
          ));
  gh.lazySingleton<_i594.MedicineRepository>(
      () => _i594.MedicineRepository(gh<_i608.MedicineSyncAdapter>()));
  gh.lazySingleton<_i106.SyncScheduler>(() => _i106.SyncScheduler(
        gh<_i188.ConnectivityHelper>(),
        gh<_i594.MedicineRepository>(),
        gh<_i951.SyncStatusCubit>(),
      ));
  gh.factory<_i480.MedicineCubit>(() => _i480.MedicineCubit(
        gh<_i594.MedicineRepository>(),
        gh<_i488.MedicineService>(),
        gh<_i723.ImagePickerUtils>(),
        gh<_i393.SyncWatcherService>(),
      ));
  return getIt;
}
