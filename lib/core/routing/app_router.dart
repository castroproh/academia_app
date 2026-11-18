import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/screens/splash_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/dashboard/presentation/screens/student_dashboard_screen.dart';
import '../../features/classes/presentation/screens/my_classes_screen.dart';
import '../../features/grades/presentation/screens/my_grades_screen.dart';
import '../../features/attendance/presentation/screens/my_attendance_screen.dart';
import '../../features/progress/presentation/screens/my_progress_screen.dart';
import '../../features/profiles/presentation/screens/my_profile_screen.dart';
import '../../features/search/presentation/screens/search_users_screen.dart';
import '../../features/profiles/presentation/screens/user_profile_screen.dart';
import '../../features/profiles/presentation/screens/teacher_reviews_screen.dart';
import '../../features/teacher/presentation/screens/teacher_dashboard_screen.dart';
import '../../features/teacher/presentation/screens/teacher_groups_screen.dart';
import '../../features/teacher/presentation/screens/student_registry_screen.dart';
import '../../features/teacher/presentation/screens/evaluation_management_screen.dart';
import '../../features/teacher/presentation/screens/class_sessions_screen.dart';
import '../../features/supervision/presentation/screens/supervision_dashboard_screen.dart';
import '../../features/supervision/presentation/screens/student_activity_detail_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../shared/widgets/responsive_layout.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String studentDashboard = '/dashboard';
  static const String myClasses = '/classes';
  static const String myGrades = '/grades';
  static const String myAttendance = '/attendance';
  static const String myProgress = '/progress';
  static const String myProfile = '/profile';
  static const String searchUsers = '/search';
  static const String userProfile = '/profile/:userId';
  static const String teacherReviews = '/reviews';
  static const String teacherDashboard = '/teacher/dashboard';
  static const String teacherGroups = '/teacher/groups';
  static const String studentRegistry = '/teacher/registry';
  static const String evaluationManagement = '/teacher/evaluations';
  static const String classSessions = '/teacher/sessions';
  static const String supervisionDashboard = '/supervision';
  static const String studentActivityDetail = '/supervision/activity/:studentId';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => ResponsiveLayout(child: child),
        routes: [
          GoRoute(
            path: studentDashboard,
            name: 'studentDashboard',
            builder: (context, state) => const StudentDashboardScreen(),
          ),
          GoRoute(
            path: myClasses,
            name: 'myClasses',
            builder: (context, state) => const MyClassesScreen(),
          ),
          GoRoute(
            path: myGrades,
            name: 'myGrades',
            builder: (context, state) => const MyGradesScreen(),
          ),
          GoRoute(
            path: myAttendance,
            name: 'myAttendance',
            builder: (context, state) => const MyAttendanceScreen(),
          ),
          GoRoute(
            path: myProgress,
            name: 'myProgress',
            builder: (context, state) => const MyProgressScreen(),
          ),
          GoRoute(
            path: myProfile,
            name: 'myProfile',
            builder: (context, state) => const MyProfileScreen(),
          ),
          GoRoute(
            path: searchUsers,
            name: 'searchUsers',
            builder: (context, state) => const SearchUsersScreen(),
          ),
          GoRoute(
            path: userProfile,
            name: 'userProfile',
            builder: (context, state) {
              final userId = state.pathParameters['userId'] ?? '';
              return UserProfileScreen(userId: userId);
            },
          ),
          GoRoute(
            path: teacherReviews,
            name: 'teacherReviews',
            builder: (context, state) => const TeacherReviewsScreen(),
          ),
          GoRoute(
            path: teacherDashboard,
            name: 'teacherDashboard',
            builder: (context, state) => const TeacherDashboardScreen(),
          ),
          GoRoute(
            path: teacherGroups,
            name: 'teacherGroups',
            builder: (context, state) => const TeacherGroupsScreen(),
          ),
          GoRoute(
            path: studentRegistry,
            name: 'studentRegistry',
            builder: (context, state) => const StudentRegistryScreen(),
          ),
          GoRoute(
            path: evaluationManagement,
            name: 'evaluationManagement',
            builder: (context, state) => const EvaluationManagementScreen(),
          ),
          GoRoute(
            path: classSessions,
            name: 'classSessions',
            builder: (context, state) => const ClassSessionsScreen(),
          ),
          GoRoute(
            path: supervisionDashboard,
            name: 'supervisionDashboard',
            builder: (context, state) => const SupervisionDashboardScreen(),
          ),
          GoRoute(
            path: studentActivityDetail,
            name: 'studentActivityDetail',
            builder: (context, state) {
              final studentId = state.pathParameters['studentId'] ?? '';
              return StudentActivityDetailScreen(studentId: studentId);
            },
          ),
          GoRoute(
            path: settings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text('Página no encontrada', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(state.error.toString(), style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(studentDashboard),
              child: const Text('Ir al Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
}