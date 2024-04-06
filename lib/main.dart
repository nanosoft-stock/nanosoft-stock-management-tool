import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/add_new_product/presentation/bloc/add_new_product_bloc.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/bloc/add_new_stock_bloc.dart';
import 'package:stock_management_tool/helper/firebase_options.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';
import 'package:stock_management_tool/providers/add_new_product_provider.dart';
import 'package:stock_management_tool/providers/add_new_stock_provider.dart';
import 'package:stock_management_tool/providers/export_stock_provider.dart';
import 'package:stock_management_tool/providers/firebase_provider.dart';
import 'package:stock_management_tool/providers/side_menu_provider.dart';
import 'package:stock_management_tool/screens/authentication_screen.dart';
import 'package:stock_management_tool/screens/home_screen.dart';
import 'package:stock_management_tool/services/auth_default.dart';
import 'package:stock_management_tool/services/auth_rest_api.dart';
import 'package:stock_management_tool/services/firestore_rest_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.linux && !kIsWeb) {
    kIsDesktop = true;
    AuthRestApi().fetchApiKey();
    FirestoreRestApi().fetchApiKey();
    FirestoreRestApi().fetchProjectId();
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await AllPredefinedData().fetchData();
  // print(AllPredefinedData.data);
  await initializeDependencies();
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
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => FirebaseProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => SideMenuProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AddNewStockProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AddNewProductProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ExportStockProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Nanosoft Stock Management Tool',
          home: SafeArea(
            child: Scaffold(
              body: kIsDesktop
                  ? StreamBuilder<bool>(
                      stream: FirebaseProvider.isUserLoggedInStreamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data == true) {
                          return HomeScreen();
                        } else {
                          return const AuthenticationScreen();
                        }
                      },
                    )
                  : StreamBuilder(
                      stream: AuthDefault().authStateChanges,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return HomeScreen();
                        } else {
                          return const AuthenticationScreen();
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
