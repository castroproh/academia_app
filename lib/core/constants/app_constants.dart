class AppConstants {
  static const String appName = 'Academia';
  static const String appTagline = 'Plataforma de Gestión Académica';
  static const String appVersion = '1.0.0';
  static const String contestName = 'XXIX Concurso Nacional de Prototipos y Proyectos de Emprendimiento 2027';

  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);

  static const double maxContentWidth = 1200.0;
  static const double sidebarWidth = 280.0;
  static const double sidebarCollapsedWidth = 72.0;
  static const double topBarHeight = 64.0;
  static const double bottomNavHeight = 72.0;

  static const int mobileBreakpoint = 600;
  static const int tabletBreakpoint = 900;
  static const int desktopBreakpoint = 1200;

  static const String demoStudentCurp = 'AAAA000000HDFLRN00';
  static const String demoTeacherCurp = 'BBBB000000HDFLRN00';
  static const String demoPassword = 'demo123';

  static const List<String> mockSubjects = [
    'Matemáticas Avanzadas',
    'Física Cuántica',
    'Programación Estructurada',
    'Base de Datos',
    'Inteligencia Artificial',
    'Redes de Computadoras',
    'Ingeniería de Software',
    'Ciberseguridad',
  ];

  static const List<String> mockGroups = [
    '5°A - Ingeniería en Sistemas',
    '5°B - Ingeniería en Sistemas',
    '6°A - Ingeniería en Sistemas',
    '6°B - Ingeniería en Sistemas',
    '7°A - Ingeniería en Sistemas',
  ];

  static const List<String> mockTeachers = [
    'Dr. Carlos Mendoza',
    'Dra. Patricia López',
    'Mtro. Roberto García',
    'Dra. Ana Fernández',
    'Dr. Miguel Torres',
  ];

  static const List<String> mockStudents = [
    'María González López',
    'Juan Pérez Martínez',
    'Ana Rodríguez García',
    'Carlos Sánchez Ruiz',
    'Laura Fernández Díaz',
    'Pedro Gómez Moreno',
    'Sofía Jiménez Herrera',
    'Diego Ramírez Torres',
    'Valentina Vargas Castro',
    'Andrés Mendoza Flores',
  ];

  static const List<String> mockApplications = [
    'Visual Studio Code',
    'Chrome',
    'Discord',
    'Spotify',
    'Telegram',
    'Figma',
    'Notion',
    'Slack',
    'Zoom',
    'Teams',
  ];

  static const List<String> allowedApplications = [
    'Visual Studio Code',
    'Chrome',
    'Figma',
    'Notion',
    'Teams',
  ];
}

enum UserRole { student, teacher, admin }

enum AttendanceStatus { present, late, absent, justified }

enum EvaluationType { exam, homework, project, participation, quiz }

enum SessionStatus { scheduled, inProgress, completed, cancelled }

enum NotificationType { info, warning, success, error }

enum ThemeMode { system, light, dark }