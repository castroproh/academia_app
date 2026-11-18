# Academia - Plataforma de Gestión Académica

Prototipo visual para el XXIX Concurso Nacional de Prototipos y Proyectos de Emprendimiento 2027.

## Descripción

Aplicación multiplataforma (Android, iOS, Web, Windows, macOS, Linux) para la gestión académica integral, desarrollada con Flutter y Material Design 3.

## Características Visuales Implementadas

### Pantallas de Acceso
- **Splash Screen** - Animación de entrada con logo y nombre de la plataforma
- **Login** - Formulario con CURP, contraseña, recuperación y acceso a registro
- **Registro** - Formulario completo con validación visual

### Panel del Alumno
- **Dashboard** - Bienvenida, promedio, asistencia, próximas clases, calificaciones recientes, accesos rápidos
- **Mis Clases** - Tarjetas de materias con profesor, horario, aula y créditos
- **Mis Calificaciones** - Promedio general, gráfica por materia, lista detallada con filtros
- **Mi Asistencia** - Porcentaje, calendario visual, historial por materia
- **Mi Progreso** - Evolución semestral, reconocimientos, historial académico, progreso por materia

### Perfil y Comunidad
- **Mi Perfil** - Información personal, cuentas vinculadas, edición visual
- **Buscar Usuarios** - Búsqueda por nombre/CURP con filtros alumno/docente
- **Perfil de Usuario** - Vista de perfil ajeno con información académica
- **Reseñas Docentes** - Historial de observaciones anónimas con categorías

### Panel del Docente
- **Dashboard Docente** - Grupos, materias, alumnos, actividad reciente, accesos rápidos
- **Mis Grupos** - Lista de grupos a cargo y todos los grupos
- **Registro de Alumnos** - Directorio con búsqueda, filtros, promedio y asistencia
- **Gestión de Evaluaciones** - CRUD visual de evaluaciones con criterios y ponderaciones
- **Sesiones de Clase** - Programación, estados, lista de alumnos, acciones contextuales

### Supervisión Digital (Conceptual)
- **Dashboard Supervisión** - Alumnos en sesión, apps en uso, línea de tiempo, alertas demo
- **Detalle Actividad Alumno** - Timeline completo, gráfica de distribución, detalle por app

### Configuración
- **Configuración** - Cuenta, apariencia (tema/idioma), notificaciones granulares, privacidad, ayuda

## Datos de Demostración

- 10 estudiantes con perfiles completos
- 5 docentes con especialidades
- 8 materias con horarios y aulas
- 33 calificaciones con pesos y tipos
- 24 registros de asistencia
- 10 sesiones de clase programadas
- 5 evaluaciones con criterios
- 6 reseñas docentes
- 5 grupos académicos
- Actividad de supervisión simulada para 6 alumnos

## Credenciales de Acceso

| Rol | CURP | Contraseña |
|-----|------|------------|
| Alumno | `AAAA000000HDFLRN00` | `demo123` |
| Docente | `BBBB000000HDFLRN00` | `demo123` |

## Arquitectura

```
lib/
├── main.dart
├── core/
│   ├── theme/          # Sistema de diseño (colores, tipografía, espaciado, temas)
│   ├── constants/      # Constantes de la app
│   ├── routing/        # Configuración de GoRouter
│   └── widgets/        # Widgets base compartidos
├── data/
│   └── mock/           # Datos ficticios para demostración
├── models/             # Modelos de datos visuales
├── features/
│   ├── authentication/ # Splash, Login, Register
│   ├── dashboard/      # Dashboard alumno
│   ├── classes/        # Mis clases
│   ├── grades/         # Calificaciones
│   ├── attendance/     # Asistencia
│   ├── progress/       # Progreso académico
│   ├── profiles/       # Perfiles (mío, ajeno, reseñas)
│   ├── search/         # Búsqueda de usuarios
│   ├── teacher/        # Panel docente completo
│   ├── supervision/    # Supervisión digital conceptual
│   └── settings/       # Configuración
└── shared/
    └── widgets/        # Componentes reutilizables (Card, Button, Input, Avatar, Chip, etc.)
```

## Tecnologías

- **Flutter** 3.24+
- **Dart** 3.5+
- **Material Design 3** - Sistema de diseño completo
- **Google Fonts** - Tipografía Inter
- **Lucide Icons** - Iconografía
- **fl_chart** - Gráficas (línea, barras, circular)
- **go_router** - Navegación declarativa
- **provider** - Estado simple

## Instalación y Ejecución

### Prerrequisitos
- Flutter SDK 3.24 o superior
- Dart 3.5 o superior
- Android Studio / VS Code con extensiones Flutter
- Para web: Chrome
- Para desktop: SDKs correspondientes

### Pasos

```bash
# 1. Clonar/abrir el proyecto
cd academia_app

# 2. Obtener dependencias
flutter pub get

# 3. Verificar configuración
flutter doctor

# 4. Ejecutar en dispositivo/emulador
flutter run

# Para plataformas específicas:
flutter run -d chrome          # Web
flutter run -d windows         # Windows
flutter run -d macos           # macOS
flutter run -d linux           # Linux
flutter run -d android         # Android
flutter run -d ios             # iOS (requiere macOS)
```

### Compilación para Release

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Desktop
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## Estructura de Navegación

### Mobile
- Bottom Navigation Bar (5 destinos principales)
- Drawer lateral para navegación secundaria
- AppBar superior con menú y perfil

### Tablet/Desktop
- Sidebar lateral permanente (colapsable)
- Área de contenido adaptable
- AppBar superior con título y acciones

## Sistema de Diseño

### Colores Principales
- **Primary**: `#1E3A5F` (Azul académico oscuro)
- **Secondary**: `#006D77` (Verde azulado)
- **Tertiary**: `#C44536` (Terracota)
- **Success**: `#2E7D32`
- **Warning**: `#F57F17`
- **Error**: `#C62828`
- **Info**: `#0277BD`

### Tipografía
- **Fuente**: Inter (Google Fonts)
- **Escalas**: Display, Headline, Title, Body, Label (Large/Medium/Small)

### Espaciado
- Base: 4px (xs=4, sm=8, md=16, lg=24, xl=32, xxl=48, xxxl=64)

### Bordes
- Radius: xs=4, sm=8, md=12, lg=16, xl=24, full=9999

## Estado del Proyecto

✅ **Completado - Etapa Visual**
- Todas las 20 pantallas implementadas
- Navegación funcional (GoRouter)
- Sistema de diseño completo
- Datos de demostración realistas
- Responsive (Mobile/Tablet/Desktop)
- Temas claro/oscuro/sistema
- Componentes reutilizables

🚧 **Pendiente - Próximas Etapas**
- Backend (C# / ASP.NET Core)
- API REST
- Base de datos
- Autenticación real
- Sincronización de datos
- Supervisión real (permisos de sistema)
- Notificaciones push
- Tests unitarios y de integración
- CI/CD

## Licencia

Proyecto educativo para concurso académico. Código abierto para fines de aprendizaje.

---

**Desarrollado con ❤️ para el XXIX Concurso Nacional de Prototipos y Proyectos de Emprendimiento 2027**