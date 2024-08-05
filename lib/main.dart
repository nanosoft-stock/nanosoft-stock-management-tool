import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/local_database/local_database.dart';
import 'package:stock_management_tool/core/local_database/repositories/local_database_repository.dart';
import 'package:stock_management_tool/core/services/auth_default.dart';
import 'package:stock_management_tool/core/services/auth_rest_api.dart';
import 'package:stock_management_tool/core/services/firebase_options.dart';
import 'package:stock_management_tool/core/services/firestore_rest_api.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/core/services/network_services.dart';
import 'package:stock_management_tool/core/services/socket_io_services.dart';
import 'package:stock_management_tool/features/add_new_category/presentation/bloc/add_new_category_bloc.dart';
import 'package:stock_management_tool/features/add_new_product/presentation/bloc/add_new_product_bloc.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/bloc/add_new_stock_bloc.dart';
import 'package:stock_management_tool/features/auth/presentation/views/authentication_view.dart';
import 'package:stock_management_tool/features/home/presentation/bloc/home_bloc.dart';
import 'package:stock_management_tool/features/home/presentation/views/home_view.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/bloc/locate_stock_bloc.dart';
import 'package:stock_management_tool/features/modify_category/presentation/bloc/modify_category_bloc.dart';
import 'package:stock_management_tool/features/print_id/presentation/bloc/print_id_bloc.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/bloc/visualize_stock_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  if (defaultTargetPlatform == TargetPlatform.linux && !kIsWeb) {
    kIsLinux = true;
    await sl.get<AuthRestApi>().fetchApiKeyAndInitializePreferences();
    await sl.get<AuthRestApi>().checkUserPreviousLoginStatus();
    sl.get<FirestoreRestApi>().fetchApiKeyAndProjectId();
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await Hive.initFlutter();
  sl.get<NetworkServices>().setToLocalEnv();
  sl.get<SocketIoServices>().setToLocalEnv();
  await sl.get<SocketIoServices>().init();
  await sl.get<LocalDatabase>().init();
  await sl.get<LocalDatabaseRepository>().fetchData();
  await sl.get<LocalDatabaseRepository>().listenToCloudDatabaseChange();

  runApp(const StockManagementToolApp());
}

class StockManagementToolApp extends StatelessWidget {
  const StockManagementToolApp({super.key});

  void fetchUserData(String? email) {
    sl.get<LocalDatabaseRepository>().fetchUser(email ?? "").then(
      (value) {
        userName =
            sl.get<LocalDatabase>().userModelBox!.values.first.username ?? "";
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => sl.get<HomeBloc>(),
        ),
        BlocProvider<AddNewStockBloc>(
          create: (context) => sl.get<AddNewStockBloc>(),
        ),
        BlocProvider<AddNewProductBloc>(
          create: (context) => sl.get<AddNewProductBloc>(),
        ),
        BlocProvider<AddNewCategoryBloc>(
          create: (context) => sl.get<AddNewCategoryBloc>(),
        ),
        BlocProvider<VisualizeStockBloc>(
          create: (context) => sl.get<VisualizeStockBloc>(),
        ),
        BlocProvider<LocateStockBloc>(
          create: (context) => sl.get<LocateStockBloc>(),
        ),
        BlocProvider<ModifyCategoryBloc>(
          create: (context) => sl.get<ModifyCategoryBloc>(),
        ),
        BlocProvider<PrintIdBloc>(
          create: (context) => sl.get<PrintIdBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Nanosoft Stock Management Tool',
        home: SafeArea(
          child: Scaffold(
            body: !kIsLinux
                ? StreamBuilder(
                    stream: sl.get<AuthDefault>().authStateChanges,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        fetchUserData(snapshot.data!.email);

                        return HomeView();
                      } else {
                        return AuthenticationView();
                      }
                    },
                  )
                : StreamBuilder<bool>(
                    stream: sl
                        .get<AuthRestApi>()
                        .userLogInStatusStreamController
                        .stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return HomeView();
                      } else {
                        return AuthenticationView();
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
