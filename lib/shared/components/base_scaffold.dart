// lib/shared/components/base_scaffold.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_nav_bar.dart';
import 'custom_floating_action_button.dart';
import '../../core/config/routes.dart';

class BaseScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final bool showBottomNav;
  final bool showBackButton;
  final List<Widget>? actions;

  const BaseScaffold({
    required this.title,
    required this.body,
    this.showBottomNav = true,
    this.showBackButton = false,
    this.actions,
    super.key,
  });

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  bool _showMenu = false;
  int _currentIndex = 0;

  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
  }

  void _handleMenuItemTap(String item) {
    setState(() {
      _showMenu = false;
    });

    if (item == 'Ajouter un prospect') {
      Navigator.of(context).pushNamed(AppRoutes.addProspect);
    } else if (item == 'Ajouter un contact') {
      Navigator.of(context).pushNamed(AppRoutes.addContact);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$item sélectionné')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // determine current index from current route
    final routeName = ModalRoute.of(context)?.settings.name;
    debugPrint(
      'BaseScaffold routeName: $routeName, widget: ${widget.runtimeType}',
    );
    _currentIndex = _routeToIndex(routeName, widget);

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        showBackButton: widget.showBackButton,
        actions: widget.actions,
      ),
      body: Stack(
        children: [
          widget.body,
          if (_showMenu)
            GestureDetector(
              onTap: _toggleMenu,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),
                        _buildMenuItem(
                          'Ajouter un prospect',
                          Icons.person_add_outlined,
                        ),
                        const SizedBox(height: 12),
                        _buildMenuItem('Ajouter un contact', Icons.contacts),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: widget.showBottomNav
          ? CustomBottomNavBar(
              selectedIndex: _currentIndex,
              iconColors: _getIconColors(context, _currentIndex),
              onTap: _onNavTap,
            )
          : null,
      floatingActionButton: widget.showBottomNav
          ? CustomFloatingActionButton(
              onPressed: _toggleMenu,
              isExpanded: _showMenu,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  int _routeToIndex(String? routeName, BaseScaffold widget) {
    switch (routeName) {
      case AppRoutes.dashboard:
        return 0;
      case AppRoutes.contacts:
        return 1;
      case AppRoutes.offres:
        return 2;
      case AppRoutes.more:
        return 3;
      default:
        // Fallback: try to infer from widget.title
        final title = widget.title.toLowerCase();
        if (title.contains('contact')) return 1;
        if (title.contains('offre')) return 2;
        if (title.contains('plus') || title.contains('more')) return 3;
        return 0;
    }
  }

  List<Color> _getIconColors(BuildContext context, int selectedIndex) {
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.colorScheme.onSurface.withOpacity(0.6);
    return List.generate(
      4,
      (i) => i == selectedIndex ? selectedColor : unselectedColor,
    );
  }

  void _onNavTap(int index) {
    String target = AppRoutes.dashboard;
    switch (index) {
      case 0:
        target = AppRoutes.dashboard;
        break;
      case 1:
        target = AppRoutes.contacts;
        break;
      case 2:
        target = AppRoutes.offres;
        break;
      case 3:
        target = AppRoutes.more;
        break;
    }

    final routeName = ModalRoute.of(context)?.settings.name;
    if (routeName == target) return; // already on target

    Navigator.of(context).pushNamedAndRemoveUntil(target, (route) => false);
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return GestureDetector(
      onTap: () => _handleMenuItemTap(title),
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4CAF50)),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
