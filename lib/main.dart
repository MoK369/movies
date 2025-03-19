import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movies/core/database/hive/adapters/defined_color_adapter.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/routes/route_generator/route_generator.dart';
import 'package:movies/core/themes/app_themes.dart';
import 'package:movies/core/widgets/custom_error_widget.dart';
import 'package:movies/modules/home/home_screen.dart';

Future<void> main() async {
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await dotenv.load(fileName: "private_info.env");
  // initialize firebase
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(DefinedColorAdapter());
  Hive.registerAdapter(ResultAdapter());

  // opening boxes
  await Hive.openBox("TemplateColorsBox");
  await Hive.openBox<List<String>>("GenreImagesBox");
  await Hive.openBox<Result>("WatchList");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies Application',
      debugShowCheckedModeBanner: false,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        ErrorWidget.builder = (errorDetails) {
          return CustomErrorWidget();
        };
        return child!;
      },
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: HomeScreen.routeName,
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
