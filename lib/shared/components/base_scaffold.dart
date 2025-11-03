// lib/shared/components/base_scaffold.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_nav_bar.dart';

class BaseScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onNavTap;

  const BaseScaffold({
    required this.title,
    required this.body,
    required this.currentIndex,
    required this.onNavTap,
    super.key,
  });

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  bool _showMenu = false;

  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
  }

  void _handleMenuItemTap(String item) {
    setState(() {
      _showMenu = false;
    });
    // Handle navigation or action based on item
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$item sélectionné')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
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
                        _buildMenuItem('Mon portefeuille', Icons.account_balance_wallet),
                        const SizedBox(height: 12),
                        _buildMenuItem('Ajouter un prospect', Icons.person_add_outlined),
                        const SizedBox(height: 12),
                        _buildMenuItem('Ajouter un client', Icons.person_add),
                        const SizedBox(height: 12),
                        _buildMenuItem('Ajouter un contact', Icons.contacts),
                        const SizedBox(height: 12),
                        _buildMenuItem('Importer des contacts', Icons.upload_file),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onNavTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleMenu,
        backgroundColor: Theme.of(context).primaryColor,
        child: AnimatedRotation(
          turns: _showMenu ? 0.125 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(_showMenu ? Icons.close : Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}