import 'package:acopiatech/views/admin/account/admin_account_view.dart';
import 'package:acopiatech/views/admin/drop_off_point/drop_off_point_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:acopiatech/widgets/admin/admin_menu_provider.dart';

class AdminMenuView extends StatelessWidget {
  const AdminMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminMenuProvider(),
      child: const _AdminMenuContent(),
    );
  }
}

class _AdminMenuContent extends StatelessWidget {
  const _AdminMenuContent();

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<AdminMenuProvider>().currentIndex;

    final views = [
      const _MenuMainView(),
      const AdminAccountView(),
      const DropOffPointView(),
    ];

    return Scaffold(body: IndexedStack(index: currentIndex, children: views));
  }
}

class _MenuMainView extends StatelessWidget {
  const _MenuMainView();

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.read<AdminMenuProvider>();

    return Center(
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
            icon: Icons.home_work_rounded,
            label: 'Centros de Acopio',
            onTap: () => menuProvider.goTo(2),
          ),
        ],
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
