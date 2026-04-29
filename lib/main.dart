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
import 'features/listings/presentation/pages/home_page.dart';
import 'features/listings/presentation/pages/listing_detail_page.dart';
import 'features/chat/presentation/controllers/chat_bloc.dart';
import 'features/chat/presentation/pages/chat_page.dart';
import 'features/chat/presentation/pages/conversations_page.dart';
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
        BlocProvider(
          create: (_) => di.sl<ChatBloc>(),
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
          '/conversations': (context) => const ConversationsPage(),
          '/chat': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
            return ChatPage(
              conversationId: args?['conversationId'] as String?,
              listing: args?['listing'],
              otherUserId: args?['otherUserId'] as String?,
            );
          },
          '/listing-detail': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return ListingDetailPage(
              listing: args['listing'],
              currentUser: args['currentUser'],
            );
          },
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
