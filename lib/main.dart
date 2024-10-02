import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:talk/screen/features/auth/sign_in/bloc/auth_bloc.dart';
import 'package:talk/screen/features/home/recent/bloc/recent_bloc.dart';
import 'package:talk/utils/app_theme.dart';
import 'core/firebase_service/fire_options.dart';
import 'utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: FlutterFireConfig().config());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => RecentBloc()),
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp.router(
          title: 'Talk',
          debugShowCheckedModeBanner: false,
          theme: ChatAppThemes.coolTones(),
          routerConfig: AppRoutes.router,
        ),
      ),
    );
  }
}
