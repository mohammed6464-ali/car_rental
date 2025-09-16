import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_car_rentil/car_details.dart';
import 'package:flutter_application_car_rentil/fillter_page1.dart';
import 'package:flutter_application_car_rentil/profile_page.dart'; // 👈 صفحة البروفايل

/// =====================
///      HOME PAGE
/// =====================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<CarData> _allCars = <CarData>[
    CarData(
      image: 'assets/img/jetour_dashing.webp',
      name: 'Jetour Dashing',
      brand: 'Jetour',
      characteristics: {'Luxury', 'Automatic'},
      rating: 4.8,
      pricePerDay: 540,
      transmission: 'Luxury',
      doors: 4,
      seats: 5,
      fuelType: 'Petrol',
    ),
    CarData(
      image: 'assets/img/porche2.png',
      name: 'Porsche GT',
      brand: 'Porsche',
      characteristics: {'Sport', 'Automatic'},
      rating: 4.7,
      pricePerDay: 620,
      transmission: 'Sport',
      doors: 2,
      seats: 2,
      fuelType: 'Petrol',
    ),
    CarData(
      image: 'assets/img/masirati.png',
      name: 'Maserati 867',
      brand: 'Maserati',
      characteristics: {'Luxury', 'Sport', 'Automatic'},
      rating: 4.7,
      pricePerDay: 720,
      transmission: 'Sport',
      doors: 4,
      seats: 5,
      fuelType: 'Diesel',
    ),
  ];

  late List<CarData> _visibleCars = List.from(_allCars);

  Future<void> _openFilter() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterPage(cars: _allCars),
      ),
    );

    if (result is Map && result['results'] is List<CarData>) {
      setState(() {
        _visibleCars = List<CarData>.from(result['results']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgTop = Color(0xFF121E3F);
    const bgBottom = Color(0xFF0B1430);

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgBottom],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _Header()),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(child: _SearchBar(onFilter: _openFilter)),
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
              const SliverToBoxAdapter(child: _BrandScroller()),
              const SliverToBoxAdapter(child: SizedBox(height: 18)),

              // ===== عنوان All Cars =====
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        'All Cars',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: Color(0xFF88A9FF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              // ===== قائمة العربيات =====
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index.isOdd) return const SizedBox(height: 8);
                    final i = index ~/ 2;
                    final car = _visibleCars[i];

                    return _AnimatedCarCard(
                      delay: i * 200,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CarDetailsPage(car: car),
                            ),
                          );
                        },
                        child: Hero(
                          tag: car.name,
                          flightShuttleBuilder: (flightContext, animation, direction, fromCtx, toCtx) {
                            if (direction == HeroFlightDirection.push) {
                              return ScaleTransition(
                                scale: animation.drive(
                                  Tween(begin: 0.95, end: 1.0)
                                      .chain(CurveTween(curve: Curves.easeOut)),
                                ),
                                child: toCtx.widget,
                              );
                            } else {
                              return FadeTransition(
                                opacity: animation,
                                child: fromCtx.widget,
                              );
                            }
                          },
                          child: CarCard(
                            image: car.image,
                            name: car.name,
                            transmission: car.transmission,
                            pricePerDay: car.pricePerDay,
                            rating: car.rating,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _visibleCars.length * 2 - 1,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _GlassBottomBar(), // ✅ الناف بار المعدل
    );
  }
}

/// ================== أنيميشن للـ CarCard ==================
class _AnimatedCarCard extends StatefulWidget {
  final Widget child;
  final int delay;
  const _AnimatedCarCard({required this.child, this.delay = 0});

  @override
  State<_AnimatedCarCard> createState() => _AnimatedCarCardState();
}

class _AnimatedCarCardState extends State<_AnimatedCarCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// ================== الهيدر ==================
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.location_on, color: Colors.white70),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your location',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  'Norvey, USA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/img/profile.png'),
          )
        ],
      ),
    );
  }
}

/// ================== السيرش بار ==================
class _SearchBar extends StatelessWidget {
  final VoidCallback? onFilter;
  const _SearchBar({this.onFilter});

  @override
  Widget build(BuildContext context) {
    const grad1 = Color(0xFF79B6FF);
    const grad2 = Color(0xFF4D8FEA);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.white38),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onFilter,
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [grad1, grad2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.filter_list_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================== براندات ==================
class _BrandScroller extends StatelessWidget {
  const _BrandScroller();

  @override
  Widget build(BuildContext context) {
    final brands = [
      BrandItem('BMW', 'assets/img/bmw3.png'),
      BrandItem('Mercedes', 'assets/img/mar.png'),
      BrandItem('Porsche', 'assets/img/porche.png'),
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          if (i < brands.length) return BrandCard(item: brands[i]);
          return const _NextBrandCard();
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: brands.length + 1,
      ),
    );
  }
}

class BrandItem {
  final String name;
  final String logo;
  BrandItem(this.name, this.logo);
}

class BrandCard extends StatelessWidget {
  final BrandItem item;
  const BrandCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Image.asset(item.logo, fit: BoxFit.contain)),
          const SizedBox(height: 8),
          Text(
            item.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}

class _NextBrandCard extends StatelessWidget {
  const _NextBrandCard();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white70,
            size: 28,
          ),
        ),
      ),
    );
  }
}

/// ================== موديل السيارة ==================
class CarData {
  final String image;
  final String name;
  final String brand;
  final Set<String> characteristics;
  final double rating;
  final int pricePerDay;
  final String transmission;
  final int doors;
  final int seats;
  final String fuelType;

  CarData({
    required this.image,
    required this.name,
    required this.brand,
    required this.characteristics,
    required this.rating,
    required this.pricePerDay,
    required this.transmission,
    required this.doors,
    required this.seats,
    required this.fuelType,
  });
}

/// ================== كرت السيارة ==================
class CarCard extends StatelessWidget {
  final String image, name, transmission;
  final double rating;
  final int pricePerDay;

  const CarCard({
    super.key,
    required this.image,
    required this.name,
    required this.transmission,
    required this.rating,
    required this.pricePerDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 22,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            left: 10,
            top: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                image,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            right: 14,
            top: 14,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border, color: Colors.white70),
            ),
          ),
          Positioned(
            left: 18,
            bottom: 16,
            right: 18,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        transmission,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFFC24A)),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '\$$pricePerDay/day',
                      style: const TextStyle(
                        color: Color(0xFF88A9FF),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// ================== الناف بار ==================
class _GlassBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.06),
              border: Border.all(color: Colors.white10),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavIcon(icon: Icons.home_rounded, active: true, onTap: () {}),
                _NavIcon(icon: Icons.bookmark_border_rounded, onTap: () {}),
                _NavIcon(icon: Icons.notifications_none_rounded, onTap: () {}),
                _NavIcon(
                  icon: Icons.person_outline_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: active ? Colors.white : Colors.white70,
        ),
      ),
    );
  }
}
