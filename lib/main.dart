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
import 'features/listings/presentation/controllers/listing_bloc.dart';
import 'features/listings/presentation/pages/create_listing_page.dart';
import 'features/profile/presentation/pages/my_listings_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<auth.AuthBloc>()..add(auth.CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (_) => di.sl<ListingBloc>(),
        ),
      ],
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
          '/create-listing': (context) => const CreateListingPage(),
          '/profile': (context) => const ProfilePage(),
          '/my-listings': (context) => const MyListingsPage(),
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
    return BlocBuilder<auth.AuthBloc, auth.AuthState>(
      builder: (context, state) {
        final user = state is auth.Authenticated ? state.user : null;

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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  accountName: Text(user?.name ?? 'User'),
                  accountEmail: Text(user?.email ?? ''),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: user?.avatarUrl != null
                        ? NetworkImage(user!.avatarUrl!)
                        : null,
                    child: user?.avatarUrl == null
                        ? Text(user?.name.substring(0, 1).toUpperCase() ?? 'U')
                        : null,
                  ),
                  onDetailsPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.inventory_2),
                  title: const Text('My Listings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/my-listings');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    context.read<auth.AuthBloc>().add(auth.LogoutEvent());
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
          ),
          body: const Center(
            child: Text('Home Page - Listings Coming Soon'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/create-listing');
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
