import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../main.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  // false = Register (default first), true = Login
  bool _isLoginMode = false;

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String _errorMessage = '';
  String _successMessage = '';

  final String baseUrl = 'http://localhost:5000/api/auth';

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  void _toggleMode() {
    _animController.reverse().then((_) {
      setState(() {
        _isLoginMode = !_isLoginMode;
        _errorMessage = '';
        _successMessage = '';
      });
      _animController.forward();
    });
  }

  // ---- REGISTER ----
  Future<void> _register() async {
    setState(() { _errorMessage = ''; _successMessage = ''; });

    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() { _errorMessage = 'Please fill in all required fields'; });
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'username': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'city': _cityController.text.trim(),
          'country': _countryController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        setState(() {
          _successMessage = 'Account created! Switching to login...';
        });
        await Future.delayed(const Duration(milliseconds: 1200));
        if (mounted) {
          _toggleMode(); // Switch to login after successful registration
        }
      } else {
        setState(() { _errorMessage = data['message'] ?? 'Registration failed'; });
      }
    } catch (e) {
      setState(() { _errorMessage = 'Cannot connect to server. Is it running?'; });
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  // ---- LOGIN ----
  Future<void> _login() async {
    setState(() { _errorMessage = ''; _successMessage = ''; });

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() { _errorMessage = 'Please enter both username and password'; });
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        if (mounted) {
          appState.login();
          // Navigator is not strictly needed if appState triggers home update, 
          // but good for clearing stacks.
          Navigator.pushReplacementNamed(context, '/home', arguments: data['token']);
        }
      } else {
        setState(() { _errorMessage = data['message'] ?? 'Login failed'; });
      }
    } catch (e) {
      setState(() { _errorMessage = 'Cannot connect to server. Is it running?'; });
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ---- Styled Input Field ----
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? _obscurePassword : false,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF7B7B9A),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFFD98B2C), size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: const Color(0xFF7B7B9A),
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF8F7F4),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEAEAF0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEAEAF0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD98B2C), width: 2),
          ),
        ),
      ),
    );
  }

  // ---- Row of two fields ----
  Widget _buildFieldRow(Widget left, Widget right) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 900;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Container(
            constraints: BoxConstraints(maxWidth: isWide ? 950 : 500),
            child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
          ),
        ),
      ),
    );
  }

  // ---- WIDE LAYOUT (Desktop) — brand panel + form side by side ----
  Widget _buildWideLayout() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Row(
          children: [
            // Left: Brand panel
            Expanded(
              flex: 4,
              child: _buildBrandPanel(),
            ),
            // Right: Form panel
            Expanded(
              flex: 5,
              child: _buildFormPanel(),
            ),
          ],
        ),
      ),
    );
  }

  // ---- NARROW LAYOUT (Mobile) — stacked ----
  Widget _buildNarrowLayout() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            _buildBrandPanelCompact(),
            _buildFormPanel(),
          ],
        ),
      ),
    );
  }

  // ---- BRAND PANEL (Left side on desktop) ----
  Widget _buildBrandPanel() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD98B2C),
            Color(0xFFC47A24),
            Color(0xFFB06A1C),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.travel_explore,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Traveloop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Plan trips together.\nExplore the world with friends.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          // Feature highlights
          _brandFeature(Icons.group_rounded, 'Collaborative planning'),
          const SizedBox(height: 16),
          _brandFeature(Icons.map_rounded, 'Smart itineraries'),
          const SizedBox(height: 16),
          _brandFeature(Icons.savings_rounded, 'Split costs easily'),
        ],
      ),
    );
  }

  Widget _buildBrandPanelCompact() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD98B2C), Color(0xFFB06A1C)],
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.travel_explore, color: Colors.white, size: 40),
          const SizedBox(height: 12),
          const Text(
            'Traveloop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Plan trips together. Explore the world.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _brandFeature(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ---- FORM PANEL (Right side) ----
  Widget _buildFormPanel() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(36),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Toggle tabs
            _buildToggleTabs(),
            const SizedBox(height: 28),

            // Title
            Text(
              _isLoginMode ? 'Welcome back!' : 'Create your account',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _isLoginMode
                  ? 'Enter your credentials to continue'
                  : 'Fill in your details to get started',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF7B7B9A),
              ),
            ),
            const SizedBox(height: 24),

            // Form fields
            if (!_isLoginMode) ...[
              _buildFieldRow(
                _buildField(
                  controller: _firstNameController,
                  label: 'First Name',
                  icon: Icons.person_outline_rounded,
                ),
                _buildField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  icon: Icons.person_outline_rounded,
                ),
              ),
              _buildFieldRow(
                _buildField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildField(
                  controller: _phoneController,
                  label: 'Phone',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
              ),
              _buildFieldRow(
                _buildField(
                  controller: _cityController,
                  label: 'City',
                  icon: Icons.location_city_rounded,
                ),
                _buildField(
                  controller: _countryController,
                  label: 'Country',
                  icon: Icons.public_rounded,
                ),
              ),
            ],

            // Username — always shown
            _buildField(
              controller: _usernameController,
              label: 'Username',
              icon: Icons.alternate_email_rounded,
            ),

            // Password — always shown
            _buildField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock_outline_rounded,
              isPassword: true,
            ),

            // Error / Success messages
            if (_errorMessage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDECEA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFE05C5C), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Color(0xFFE05C5C), fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            if (_successMessage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Color(0xFF2EC4B6), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _successMessage,
                        style: const TextStyle(color: Color(0xFF2EC4B6), fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : (_isLoginMode ? _login : _register),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD98B2C),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD98B2C).withValues(alpha: 0.6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        _isLoginMode ? 'Sign In' : 'Create Account',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Switch mode text
            Center(
              child: TextButton(
                onPressed: _toggleMode,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13),
                    children: [
                      TextSpan(
                        text: _isLoginMode
                            ? "Don't have an account? "
                            : 'Already have an account? ',
                        style: const TextStyle(color: Color(0xFF7B7B9A)),
                      ),
                      TextSpan(
                        text: _isLoginMode ? 'Register' : 'Sign In',
                        style: const TextStyle(
                          color: Color(0xFFD98B2C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- TOGGLE TABS ----
  Widget _buildToggleTabs() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7F4),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(child: _buildTab('Register', !_isLoginMode)),
          Expanded(child: _buildTab('Login', _isLoginMode)),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if ((label == 'Login') != _isLoginMode) _toggleMode();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF1A1A2E) : const Color(0xFF7B7B9A),
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
