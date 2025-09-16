import 'package:flutter/material.dart';

import 'home_page.dart' show CarData; // نحتاج الموديل

class FilterPage extends StatefulWidget {
  final List<CarData> cars; // كل العربيات
  final String? initialBrand; // براند مبدئي (اختياري)
  final Set<String>? initialChars; // خصائص مبدئية
  final RangeValues? initialPriceRange; // رينج سعر مبدئي

  const FilterPage({
    super.key,
    required this.cars,
    this.initialBrand,
    this.initialChars,
    this.initialPriceRange,
  });

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // UI Colors
  static const grad1 = Color(0xFF79B6FF);
  static const grad2 = Color(0xFF4D8FEA);

  // البراندات + الخصائص المطلوبة
  final List<String> _brands = [
    'BMW',
    'Mercedes',
    'Maserati',
    'Jetour',
    'Range Rover',
    'Lamborghini',
  ];
  final List<String> _charOptions = const ['Luxury', 'Sport', 'Automatic'];

  // حالة الفلاتر
  late RangeValues _priceRange;
  String? _selectedBrand;
  late Set<String> _selectedChars;

  @override
  void initState() {
    super.initState();
    _selectedBrand = widget.initialBrand;
    _selectedChars = {...(widget.initialChars ?? {})};

    // نحسب أقل/أعلى سعر موجودين كـ default
    final prices = widget.cars.map((c) => c.pricePerDay).toList()..sort();
    final minP = prices.first.toDouble();
    final maxP = prices.last.toDouble();
    _priceRange = widget.initialPriceRange ?? RangeValues(minP, maxP);
  }

  List<CarData> _applyFilters() {
    return widget.cars.where((c) {
      // سعر
      final inPrice =
          c.pricePerDay >= _priceRange.start &&
          c.pricePerDay <= _priceRange.end;
      // براند
      final inBrand = _selectedBrand == null || c.brand == _selectedBrand;
      // خصائص
      final inChars =
          _selectedChars.isEmpty ||
          _selectedChars.every((tag) => c.characteristics.contains(tag));
      return inPrice && inBrand && inChars;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _applyFilters();

    return Scaffold(
  extendBodyBehindAppBar: true, // ✅ مهم عشان الخلفية تبقى ورا الـ AppBar
  appBar: AppBar(
    backgroundColor: Colors.transparent, // ✅ شفاف
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.white, // السهم أبيض
      ),
      onPressed: () => Navigator.pop(context),
    ),
    title: const Text(
      'Filter',
      style: TextStyle(
        color: Colors.white, // النص أبيض
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    centerTitle: true,
  ),

  body: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF121E3F), Color(0xFF0B1430)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
    ),
    child: SafeArea( // ✅ يحمي المحتوى من الدخول تحت الـ notch
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // ===== السعر =====
              const Text(
                "All Cars",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              RangeSlider(
                values: _priceRange,
                min: widget.cars
                    .map((c) => c.pricePerDay)
                    .reduce((a, b) => a < b ? a : b)
                    .toDouble(),
                max: widget.cars
                    .map((c) => c.pricePerDay)
                    .reduce((a, b) => a > b ? a : b)
                    .toDouble(),
                divisions: 20,
                activeColor: grad2,
                inactiveColor: Colors.white24,
                labels: RangeLabels(
                  "\$${_priceRange.start.round()}",
                  "\$${_priceRange.end.round()}",
                ),
                onChanged: (val) => setState(() => _priceRange = val),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _priceBox("\$${_priceRange.start.round()}"),
                  _priceBox("\$${_priceRange.end.round()}"),
                ],
              ),
              const SizedBox(height: 22),

              // ===== البراندات =====
              const Text(
                "Brands",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    _brands.map((b) {
                      final selected = _selectedBrand == b;
                      return _chip(
                        b,
                        selected,
                        onTap: () => setState(() => _selectedBrand = b),
                      );
                    }).toList()..insert(
                      0,
                      _chip(
                        'All',
                        _selectedBrand == null,
                        onTap: () => setState(() => _selectedBrand = null),
                      ),
                    ),
              ),
              const SizedBox(height: 24),

              // ===== الخصائص =====
              const Text(
                "Vehicle Characteristics",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _charOptions.map((c) {
                  final selected = _selectedChars.contains(c);
                  return _chip(
                    c,
                    selected,
                    onTap: () => setState(() {
                      selected
                          ? _selectedChars.remove(c)
                          : _selectedChars.add(c);
                    }),
                  );
                }).toList(),
              ),

              const Spacer(),

              // ===== زر النتائج =====
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // نرجّع النتائج + الفلاتر للصفحة السابقة
                    Navigator.pop(context, {
                      'brand': _selectedBrand,
                      'chars': _selectedChars,
                      'range': _priceRange,
                      'results': filtered,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Center(
                      child: Text(
                        "Show ${filtered.length} Results",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    )
    );
  }

  // ===== Widgets مساعدة =====

  Widget _chip(String label, bool selected, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(colors: [grad1, grad2])
              : null,
          color: selected ? null : Colors.white.withOpacity(.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _priceBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [grad1, grad2]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
