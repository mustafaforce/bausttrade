import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/supabase_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/controllers/auth_bloc.dart' as auth;
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  final envFile = File('${directory.path}/.env');

  if (!await envFile.exists()) {
    final data = await rootBundle.loadString('.env');
    await envFile.writeAsString(data);
  }

  await SupabaseConstants.load();

  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

  await di.init();

  runApp(const BaustTradeApp());
}

class BaustTradeApp extends StatelessWidget {
  const BaustTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<auth.AuthBloc>()..add(auth.CheckAuthStatusEvent()),
      child: MaterialApp(
        title: 'Baust CampusTrade',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<auth.AuthBloc, auth.AuthState>(
      builder: (context, state) {
        if (state is auth.AuthLoading || state is auth.AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is auth.Authenticated) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baust CampusTrade'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<auth.AuthBloc>().add(auth.LogoutEvent());
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Home Page - Listings Coming Soon'),
      ),
    );
  }
}
