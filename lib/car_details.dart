// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_application_car_rentil/select_date.dart';
import 'home_page.dart' show CarData;

class CarDetailsPage extends StatefulWidget {
  final CarData car;

  const CarDetailsPage({super.key, required this.car});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage>
    with TickerProviderStateMixin {
  static const bgTop = Color(0xFF121E3F);
  static const bgBottom = Color(0xFF0B1430);
  static const grad1 = Color(0xFF79B6FF);
  static const grad2 = Color(0xFF4D8FEA);

  late final AnimationController _controller;
  late final Animation<double> _fadeImg, _fadeTitle, _fadeGrid, _fadeBottom;
  late final Animation<Offset> _slideImg, _slideTitle, _slideGrid;

  double _angle = 0; // زاوية الدوران

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _fadeImg = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    _fadeTitle = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.5, curve: Curves.easeOut),
    );
    _fadeGrid = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.8, curve: Curves.easeOut),
    );
    _fadeBottom = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    );

    _slideImg = Tween<Offset>(
      begin: const Offset(0, .08),
      end: Offset.zero,
    ).animate(_fadeImg);
    _slideTitle = Tween<Offset>(
      begin: const Offset(0, .1),
      end: Offset.zero,
    ).animate(_fadeTitle);
    _slideGrid = Tween<Offset>(
      begin: const Offset(0, .12),
      end: Offset.zero,
    ).animate(_fadeGrid);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _featureCard(IconData icon, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[300]),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          car.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgBottom],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة العربية مع 360°
                    FadeTransition(
                      opacity: _fadeImg,
                      child: SlideTransition(
                        position: _slideImg,
                        child: Column(
                          children: [
                            GestureDetector(
                              onHorizontalDragUpdate: (d) {
                                setState(() {
                                  _angle += d.delta.dx * 0.01;
                                });
                              },
                              child: Transform.rotate(
                                angle: _angle,
                                child: Hero(
                                  tag: car.name,
                                  child: SizedBox(
                                    height: 230,
                                    child: Image.asset(
                                      car.image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.threed_rotation,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Drag to rotate 360°",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // All Features
                    FadeTransition(
                      opacity: _fadeTitle,
                      child: SlideTransition(
                        position: _slideTitle,
                        child: const Text(
                          "All Features",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Grid of Features
                    FadeTransition(
                      opacity: _fadeGrid,
                      child: SlideTransition(
                        position: _slideGrid,
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.3,
                          children: [
                            _featureCard(
                              Icons.settings,
                              "Transmission",
                              car.transmission,
                            ),
                            _featureCard(
                              Icons.airline_seat_recline_extra,
                              "Doors & Seats",
                              "${car.doors} Door & ${car.seats} Seats",
                            ),
                            _featureCard(
                              Icons.ac_unit,
                              "Air Condition",
                              "Climate Control",
                            ),
                            _featureCard(
                              Icons.local_gas_station,
                              "Fuel Type",
                              car.fuelType,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // السعر + زر Book Now (ثابت تحت)
            // السعر + زر Book Now (ثابت تحت)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [bgTop.withOpacity(.20), bgBottom.withOpacity(.95)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // السعر يسار
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Total Price",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "\$${car.pricePerDay}/day",
                            style: const TextStyle(
                              color: Color(0xFF88A9FF),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),

                      // زر Book Now يمين
                      SizedBox(
                        width: 160, // 👈 عرض مضبوط
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SelectDatePage(
                                  pricePerDay: widget.car.pricePerDay,
                                  carImage: widget.car.image,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Ink(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [grad1, grad2],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Book Now",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
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
}
