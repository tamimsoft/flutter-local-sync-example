// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:instance_a/app/core/services/database/app_db.dart' as _i168;
import 'package:instance_a/app/core/services/database/local/hive_db_impl.dart'
    as _i107;
import 'package:instance_a/app/core/services/sync/repository/generic_sync_repository.dart'
    as _i603;
import 'package:instance_a/app/core/services/sync/service/sync_manager_service.dart'
    as _i737;
import 'package:instance_a/app/core/services/sync/service/sync_service.dart'
    as _i753;
import 'package:instance_a/app/core/services/sync/ui/cubit/sync_status_cubit.dart'
    as _i640;
import 'package:instance_a/app/core/utils/connectivity_helper.dart' as _i1010;
import 'package:instance_a/app/core/utils/image_picker_utils.dart' as _i890;
import 'package:instance_a/app/features/medicine/adapter/medicine_sync_adapter.dart'
    as _i857;
import 'package:instance_a/app/features/medicine/data/repository/medicine_repository.dart'
    as _i78;
import 'package:instance_a/app/features/medicine/service/medicine_service.dart'
    as _i877;
import 'package:instance_a/app/features/medicine/ui/cubit/medicine_cubit.dart'
    as _i749;

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
  gh.factory<_i877.MedicineService>(() => _i877.MedicineService());
  gh.singleton<_i1010.ConnectivityHelper>(() => _i1010.ConnectivityHelper());
  gh.lazySingleton<_i890.ImagePickerUtils>(() => _i890.ImagePickerUtils());
  gh.lazySingleton<_i640.SyncStatusCubit>(() => _i640.SyncStatusCubit());
  gh.lazySingleton<_i857.MedicineSyncAdapter>(
      () => _i857.MedicineSyncAdapter());
  gh.singleton<_i737.SyncManagerService>(() => _i737.SyncManagerService(
        gh<_i1010.ConnectivityHelper>(),
        gh<_i640.SyncStatusCubit>(),
      ));
  gh.lazySingleton<_i168.AppDb>(() => _i107.HiveDbImpl());
  gh.lazySingleton<_i753.SyncService>(
      () => _i753.SyncService(gh<_i1010.ConnectivityHelper>()));
  gh.lazySingleton<_i78.MedicineRepository>(
      () => _i78.MedicineRepository(gh<_i857.MedicineSyncAdapter>()));
  gh.lazySingleton<_i603.GenericSyncRepository<dynamic>>(
      () => _i603.GenericSyncRepository<dynamic>(
            gh<_i168.AppDb>(),
            gh<_i753.SyncService>(),
          ));
  gh.factory<_i749.MedicineCubit>(() => _i749.MedicineCubit(
        gh<_i78.MedicineRepository>(),
        gh<_i877.MedicineService>(),
        gh<_i890.ImagePickerUtils>(),
        gh<_i737.SyncManagerService>(),
      ));
  return getIt;
}
