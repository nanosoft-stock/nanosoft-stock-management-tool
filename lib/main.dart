import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/core/data/local_database/store_to_objectbox.dart';
import 'package:stock_management_tool/features/add_new_product/presentation/bloc/add_new_product_bloc.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/bloc/add_new_stock_bloc.dart';
import 'package:stock_management_tool/features/auth/presentation/views/authentication_view.dart';
import 'package:stock_management_tool/features/home/presentation/bloc/home_bloc.dart';
import 'package:stock_management_tool/features/home/presentation/views/home_screen.dart';
import 'package:stock_management_tool/helper/firebase_options.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:stock_management_tool/providers/export_stock_provider.dart';
import 'package:stock_management_tool/services/auth_default.dart';
import 'package:stock_management_tool/services/auth_rest_api.dart';
import 'package:stock_management_tool/services/firestore_rest_api.dart';

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

  await sl.get<ObjectBox>().create();
  await StoreToObjectbox(sl.get<ObjectBox>()).fetchData(deletePrevious: true);
  await AllPredefinedData().fetchData();

  runApp(const StockManagementToolApp());
}

class StockManagementToolApp extends StatelessWidget {
  const StockManagementToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddNewProductBloc>(
          create: (context) => sl.get<AddNewProductBloc>(),
        ),
        BlocProvider<AddNewStockBloc>(
          create: (context) => sl.get<AddNewStockBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => sl.get<HomeBloc>(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ExportStockProvider(),
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
                          return HomeView();
                        } else {
                          return AuthenticationView();
                        }
                      },
                    )
                  : StreamBuilder<bool>(
                      stream: sl.get<AuthRestApi>().userLogInStatusStreamController.stream,
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
      ),
    );
  }
}
