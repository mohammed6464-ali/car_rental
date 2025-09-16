import 'package:flutter/material.dart';
import 'login_page.dart'; // غيّر المسار لو مختلف

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: اربط بـ Firebase Auth: createUserWithEmailAndPassword(...)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signing up...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgTop = Color(0xFF10203E);
    const bgBottom = Color(0xFF0B1430);
    const primaryStart = Color(0xFF79B6FF);
    const primaryEnd = Color(0xFF4D8FEA);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgBottom],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Create New Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Set up your username and password.\nYou can always change it later.',
                    style: TextStyle(color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 28),

                  // Name
                  _Input(
                    controller: _nameCtrl,
                    hint: 'Full Name',
                    prefix: const Icon(Icons.person_outline, color: Colors.lightBlueAccent),
                    validator: (v) => (v == null || v.trim().length < 2)
                        ? 'Enter a valid name'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  _Input(
                    controller: _emailCtrl,
                    hint: 'Email',
                    keyboard: TextInputType.emailAddress,
                    prefix: const Icon(Icons.email_outlined, color: Colors.lightBlueAccent),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email is required';
                      final ok = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(v);
                      return ok ? null : 'Enter a valid email';
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  _Input(
                    controller: _passCtrl,
                    hint: 'Password',
                    obscure: _obscure1,
                    prefix: const Icon(Icons.lock_outline, color: Colors.lightBlueAccent),
                    suffix: IconButton(
                      icon: Icon(
                        _obscure1 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.white60,
                      ),
                      onPressed: () => setState(() => _obscure1 = !_obscure1),
                    ),
                    validator: (v) => (v == null || v.length < 6)
                        ? 'At least 6 characters'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  _Input(
                    controller: _confirmCtrl,
                    hint: 'Confirm Password',
                    obscure: _obscure2,
                    prefix: const Icon(Icons.lock_outline, color: Colors.lightBlueAccent),
                    suffix: IconButton(
                      icon: Icon(
                        _obscure2 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.white60,
                      ),
                      onPressed: () => setState(() => _obscure2 = !_obscure2),
                    ),
                    validator: (v) =>
                        (v != _passCtrl.text) ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 26),

                  // Sign Up button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryStart, primaryEnd],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                        child: const Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ',
                          style: TextStyle(color: Colors.white70)),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: const [
                      Expanded(child: Divider(color: Colors.white24)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Or sign in with', style: TextStyle(color: Colors.white54)),
                      ),
                      Expanded(child: Divider(color: Colors.white24)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {/* TODO: Google Sign-In */},
                          icon: Image.asset('assets/img/google1.webp', height: 20),
                          label: const Text('Google', style: TextStyle(color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {/* TODO: Facebook Sign-In */},
                          icon: Image.asset('assets/img/facebook.png', height: 20),
                          label: const Text('Facebook', style: TextStyle(color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboard;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscure;
  final String? Function(String?)? validator;

  const _Input({
    required this.controller,
    required this.hint,
    this.keyboard = TextInputType.text,
    this.prefix,
    this.suffix,
    this.obscure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60),
        prefixIcon: prefix,
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      ),
    );
    }
}
