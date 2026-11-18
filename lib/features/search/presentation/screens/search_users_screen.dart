import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../features/authentication/presentation/providers/auth_provider.dart';
import '../../../../data/mock/mock_data.dart';
import '../../../../models/academic_models.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../../../../shared/widgets/app_sidebar.dart';
import '../../../../shared/widgets/app_bottom_navigation.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../../../shared/widgets/app_input.dart';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  String _selectedFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Alumnos', 'Docentes'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    final allUsers = [...MockData.students, ...MockData.teachers];
    final filteredUsers = _filterUsers(allUsers);

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: 'Buscar Usuarios',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Buscar Usuarios'),
        drawer: context.isMobile ? AppSidebar(isCollapsed: false) : null,
        body: Column(
          children: [
            _buildSearchBar(theme),
            _buildFilterChips(theme),
            Expanded(
              child: _buildResultsList(theme, filteredUsers),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: AppSearchField(
        controller: _searchController,
        hint: 'Buscar por nombre o código...',
        onChanged: (_) => setState(() {}),
        onClear: () => setState(() {}),
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: EdgeInsets.only(right: filter == _filters.last ? 0 : AppSpacing.sm),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedFilter = filter),
                backgroundColor: theme.colorScheme.surfaceContainer,
                selectedColor: theme.colorScheme.primaryContainer,
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                ),
                side: BorderSide(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                  width: isSelected ? 2 : 1,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.full)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildResultsList(ThemeData theme, List<User> users) {
    if (_searchController.text.isEmpty && _selectedFilter == 'Todos') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_rounded, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
            const SizedBox(height: AppSpacing.md),
            Text('Busca usuarios por nombre o código', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xs),
            Text('Escribe en la barra de búsqueda para comenzar', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search_rounded, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
            const SizedBox(height: AppSpacing.md),
            Text('No se encontraron usuarios', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xs),
            Text('Intenta con otros términos de búsqueda', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserCard(theme, user);
      },
    );
  }

  List<User> _filterUsers(List<User> users) {
    var filtered = users.where((u) => u.id != context.read<AuthProvider>().currentUser?.id).toList();

    if (_selectedFilter == 'Alumnos') {
      filtered = filtered.where((u) => u.role == UserRole.student).toList();
    } else if (_selectedFilter == 'Docentes') {
      filtered = filtered.where((u) => u.role == UserRole.teacher).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((u) =>
        u.fullName.toLowerCase().contains(query) ||
        u.id.toLowerCase().contains(query) ||
        u.curp.toLowerCase().contains(query)
      ).toList();
    }

    return filtered;
  }

  Widget _buildUserCard(ThemeData theme, User user) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      onTap: () => context.go('${AppRouter.userProfile}/${user.id}'),
      child: Row(
        children: [
          AppAvatar(name: user.fullName, radius: 28, showBorder: true),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(user.fullName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                    const SizedBox(width: AppSpacing.sm),
                    AppBadge(
                      text: user.role == UserRole.student ? 'Alumno' : 'Docente',
                      variant: user.role == UserRole.student ? BadgeVariant.info : BadgeVariant.standard,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(user.institution, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                if (user.role == UserRole.student) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text('${user.career} • ${user.group}', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ] else ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(user.career, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}