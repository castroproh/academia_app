import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final Widget? sidebar;
  final Widget? bottomNavigation;
  final bool showSidebar;
  final bool showBottomNav;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.sidebar,
    this.bottomNavigation,
    this.showSidebar = true,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1200;
        final isDesktop = constraints.maxWidth >= 1200;

        if (isMobile) {
          return _MobileLayout(
            child: child,
            bottomNavigation: bottomNavigation,
            showBottomNav: showBottomNav,
          );
        }

        if (isTablet) {
          return _TabletLayout(
            child: child,
            sidebar: sidebar,
            bottomNavigation: bottomNavigation,
            showSidebar: showSidebar,
            showBottomNav: showBottomNav,
          );
        }

        return _DesktopLayout(
          child: child,
          sidebar: sidebar,
          showSidebar: showSidebar,
        );
      },
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final Widget child;
  final Widget? bottomNavigation;
  final bool showBottomNav;

  const _MobileLayout({
    required this.child,
    this.bottomNavigation,
    required this.showBottomNav,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: showBottomNav && bottomNavigation != null
          ? bottomNavigation
          : null,
    );
  }
}

class _TabletLayout extends StatefulWidget {
  final Widget child;
  final Widget? sidebar;
  final Widget? bottomNavigation;
  final bool showSidebar;
  final bool showBottomNav;

  const _TabletLayout({
    required this.child,
    this.sidebar,
    this.bottomNavigation,
    required this.showSidebar,
    required this.showBottomNav,
  });

  @override
  State<_TabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<_TabletLayout> {
  bool _showSidebar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (widget.showSidebar && widget.sidebar != null && _showSidebar)
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: _showSidebar ? 280 : 0,
              child: _showSidebar ? widget.sidebar : const SizedBox.shrink(),
            ),
          Expanded(
            child: Scaffold(
              body: SafeArea(child: widget.child),
              bottomNavigationBar: widget.showBottomNav && widget.bottomNavigation != null
                  ? widget.bottomNavigation
                  : null,
            ),
          ),
        ],
      ),
      floatingActionButton: widget.showSidebar && widget.sidebar != null
          ? FloatingActionButton(
              onPressed: () => setState(() => _showSidebar = !_showSidebar),
              child: Icon(_showSidebar ? Icons.chevron_left : Icons.chevron_right),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final Widget child;
  final Widget? sidebar;
  final bool showSidebar;

  const _DesktopLayout({
    required this.child,
    this.sidebar,
    required this.showSidebar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (showSidebar && sidebar != null)
            SizedBox(width: 280, child: sidebar),
          Expanded(
            child: Scaffold(
              body: SafeArea(child: child),
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  T resolve(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200 && desktop != null) return desktop!;
    if (width >= 600 && tablet != null) return tablet!;
    return mobile;
  }
}

extension ResponsiveExtension on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < 600;
  bool get isTablet => MediaQuery.of(this).size.width >= 600 && MediaQuery.of(this).size.width < 1200;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1200;
}