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

class TeacherReviewsScreen extends StatefulWidget {
  const TeacherReviewsScreen({super.key});

  @override
  State<TeacherReviewsScreen> createState() => _TeacherReviewsScreenState();
}

class _TeacherReviewsScreenState extends State<TeacherReviewsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedCategory = 'Todas';
  final List<String> _categories = ['Todas', 'Explicación', 'Metodología', 'Evaluación', 'Disponibilidad', 'Conocimiento', 'Práctica'];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    final reviews = _selectedCategory == 'Todas'
        ? MockData.teacherReviews
        : MockData.teacherReviews.where((r) => r.category == _selectedCategory).toList();

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: 'Reseñas Docentes',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Reseñas Docentes'),
        drawer: context.isMobile ? AppSidebar(isCollapsed: false) : null,
        body: Column(
          children: [
            _buildHeader(theme),
            _buildCategoryFilter(theme),
            Expanded(
              child: _buildReviewsList(theme, reviews),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reseñas Docentes', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.xs),
                Text('Observaciones y calificaciones de profesores', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          AppButton(
            label: 'Escribir reseña',
            icon: Icons.edit_rounded,
            variant: ButtonVariant.filled,
            onPressed: () => _showWriteReviewDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category;
            return Padding(
              padding: EdgeInsets.only(right: category == _categories.last ? 0 : AppSpacing.sm),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedCategory = category),
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

  Widget _buildReviewsList(ThemeData theme, List<TeacherReview> reviews) {
    if (reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review_rounded, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
            const SizedBox(height: AppSpacing.md),
            Text('Sin reseñas', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xs),
            Text('No hay reseñas para esta categoría', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return _buildReviewCard(theme, review);
      },
    );
  }

  Widget _buildReviewCard(ThemeData theme, TeacherReview review) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(name: review.teacherName, radius: 20),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.teacherName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                    Text(review.category, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < review.rating ? Icons.star_rounded : Icons.star_border_rounded,
                  color: AppColors.warning,
                  size: 18,
                )),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(review.content, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.isAnonymous ? 'Reseña anónima' : 'Por ${review.studentName}',
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              Text(_formatDate(review.date), style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }

  void _showWriteReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escribir reseña'),
        content: const Text('Esta es una funcionalidad de demostración. En la versión final, podrás escribir una reseña anónima para un docente.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendido')),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}