import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/collection_storage.dart';
import 'package:acopiatech/views/user/account/user_account_view.dart';
import 'package:acopiatech/views/user/address/user_address_view.dart';
import 'package:acopiatech/widgets/user/user_menu_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class UserMenuView extends StatelessWidget {
  const UserMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollectionBloc(CollectionStorage()),
      child: ChangeNotifierProvider(
        create: (_) => UserMenuProvider(),
        child: const _UserMenuContent(),
      ),
    );
  }
}

class _UserMenuContent extends StatelessWidget {
  const _UserMenuContent();

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<UserMenuProvider>().currentIndex;

    final views = [
      const _MenuMainView(),
      const UserAccountView(),
      const UserAddressView(),
    ];

    return Scaffold(body: IndexedStack(index: currentIndex, children: views));
  }
}

class _MenuMainView extends StatelessWidget {
  const _MenuMainView();

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.read<UserMenuProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          context.read<UserMenuProvider>().goTo(0);
        }
      },
      child: Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            _MenuTile(
              icon: Icons.person,
              label: 'Perfil',
              onTap: () => menuProvider.goTo(1),
            ),
            _MenuTile(
              icon: Icons.delivery_dining_rounded,
              label: 'Direcciones',
              onTap: () => menuProvider.goTo(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.black12),
        ),
        shadowColor: Colors.grey[300],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 60),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
