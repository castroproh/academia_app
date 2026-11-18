import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../models/academic_models.dart';
import '../../../../data/mock/mock_data.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  UserRole? _currentRole;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  UserRole? get currentRole => _currentRole;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isStudent => _currentRole == UserRole.student;
  bool get isTeacher => _currentRole == UserRole.teacher;

  Future<void> login(String curp, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    if (curp == AppConstants.demoStudentCurp && password == AppConstants.demoPassword) {
      _currentUser = MockData.currentStudent;
      _currentRole = UserRole.student;
    } else if (curp == AppConstants.demoTeacherCurp && password == AppConstants.demoPassword) {
      _currentUser = MockData.currentTeacher;
      _currentRole = UserRole.teacher;
    } else {
      _errorMessage = 'CURP o contraseña incorrectos. Usa los datos de demostración.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String fullName, String curp, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    _currentUser = User(
      id: 'STU${DateTime.now().millisecondsSinceEpoch}',
      curp: curp,
      fullName: fullName,
      email: '$curp@estudiante.edu.mx',
      phone: '',
      avatarUrl: '',
      role: UserRole.student,
      institution: 'Instituto Tecnológico Nacional',
      career: 'Ingeniería en Sistemas Computacionales',
      group: '5°A',
      description: 'Nuevo estudiante registrado.',
      createdAt: DateTime.now(),
    );
    _currentRole = UserRole.student;

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _currentRole = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void switchRole(UserRole role) {
    _currentRole = role;
    if (role == UserRole.student) {
      _currentUser = MockData.currentStudent;
    } else {
      _currentUser = MockData.currentTeacher;
    }
    notifyListeners();
  }
}