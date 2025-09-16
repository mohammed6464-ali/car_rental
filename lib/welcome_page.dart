// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'login_page.dart'; // ✨ غيّر المسار لو صفحة اللوجين عندك في مكان تاني

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _controller = PageController();
  int _index = 0;

  final _pages = const [
    _OnbData(
      title: 'Locate the Destination',
      subtitle:
          'Your destination is at your fingertips. Open app & enter where you want to go',
      image: 'assets/img/car5.png',
    ),
    _OnbData(
      title: 'Book Your Ride',
      subtitle:
          'Pick a car that suits you best. Clean UI with quick booking & tracking',
      image: 'assets/img/car6.png',
    ),
    _OnbData(
      title: 'Arrive Safely',
      subtitle:
          'Real-time updates, secure payments, and reliable support — all in one place',
      image: 'assets/img/car8.png',
    ),
  ];

  void _next() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
      );
    } else {
      // آخر صفحة → افتح صفحة تسجيل الدخول
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  void _skip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const bgTop = Color(0xFF10203E);
    const bgBottom = Color(0xFF0B1430);
    const primaryStart = Color(0xFF79B6FF);
    const primaryEnd = Color(0xFF4D8FEA);
    const textSub = Color(0xFFB8C2D6);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgBottom],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // الصفحات
              PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                    child: Stack(
                      children: [
                        // الصورة في النص
                        Align(
                          alignment: Alignment.center,
                          child: IgnorePointer(
                            ignoring: true,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: size.width * 1.2,
                                maxHeight: size.height * 0.75,
                              ),
                              child: Image.asset(
                                p.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        // النصوص + الزرار
                        Positioned.fill(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              _GradientText(
                                p.title,
                                style: TextStyle(
                                  fontSize: size.width * .082,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                                gradient: const LinearGradient(
                                  colors: [primaryStart, primaryEnd],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                p.subtitle,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: textSub,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: List.generate(
                                  _pages.length,
                                  (dot) => _Dot(active: dot == _index),
                                ),
                              ),
                              const Spacer(),
                              // زر Next / Get Started
                              SizedBox(
                                width: 160,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _next,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Ink(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [primaryStart, primaryEnd],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(14),
                                      ),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _index ==
                                                    _pages.length - 1
                                                ? 'Get Started'
                                                : 'Next',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            _index ==
                                                    _pages.length - 1
                                                ? Icons.check_rounded
                                                : Icons.arrow_right_alt_rounded,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // زر Skip
              Positioned(
                top: 8,
                right: 12,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// البيانات
class _OnbData {
  final String title, subtitle, image;
  const _OnbData({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

// نص بجراديانت
class _GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;
  const _GradientText(this.text,
      {required this.style, required this.gradient, super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => gradient.createShader(rect),
      blendMode: BlendMode.srcIn,
      child: Text(text, style: style),
    );
  }
}

// نقطة المؤشر
class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: active ? 28 : 8,
      decoration: BoxDecoration(
        color: active ? Colors.white.withOpacity(.9) : Colors.white24,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
