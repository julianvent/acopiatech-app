import 'package:acopiatech/helpers/loading/loading_screen.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/services/auth/firebase_auth_provider.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/address/address_storage.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/collection_storage.dart';
import 'package:acopiatech/views/forgot_password_view.dart';
import 'package:acopiatech/views/login_view.dart';
import 'package:acopiatech/views/register_view.dart';
import 'package:acopiatech/views/user/address/create_update_address_view.dart';
import 'package:acopiatech/views/verification_view.dart';
import 'package:acopiatech/widgets/admin/Admin_navigation_bar.dart';
import 'package:acopiatech/widgets/admin/admin_navigation_controller.dart';
import 'package:acopiatech/widgets/user/user_navigation_bar.dart';
import 'package:acopiatech/widgets/user/user_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('es_ES', null).then(
    (_) => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AcopiaTech',
        locale: const Locale('es', 'ES'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          textTheme: GoogleFonts.rubikTextTheme(),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
            },
          ),
        ),
        home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const HomePage(),
        ),
        routes: {
          '/login': (context) => const LoginView(),
          '/create-address':
              (context) => const CreateUpdateAddressView(title: ''),
        },
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Por favor espere un momento...',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn || state is AuthStateLoggedInAsAdmin) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AddressBloc>(
                create: (context) => AddressBloc(AddressStorage()),
              ),
              BlocProvider<CollectionBloc>(
                create: (context) => CollectionBloc(CollectionStorage()),
              ),
            ],
            child:
                state is AuthStateLoggedInAsAdmin
                    ? const AdminNavigationBar()
                    : const UserNavigationBar(),
          );
        } else if (state is AuthStateNeedsVerification) {
          return const VerificationView();
        } else if (state is AuthStateLoggedOut) {
          if (Get.isRegistered<UserNavigationController>()) {
            Get.delete<UserNavigationController>();
          } else {
            Get.delete<AdminNavigationController>();
          }
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
