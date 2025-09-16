import 'package:flutter/material.dart';
import 'package:flutter_application_car_rentil/payment_page.dart';

class SelectDatePage extends StatefulWidget {

  final int pricePerDay;
  final String carImage;
  const SelectDatePage({super.key, required this.pricePerDay, required this.carImage, });

  @override
  State<SelectDatePage> createState() => _SelectDatePageState();
}

class _SelectDatePageState extends State<SelectDatePage> {
  // Colors
  static const bgTop = Color(0xFF121E3F);
  static const bgBottom = Color(0xFF0B1430);
  static const grad1 = Color(0xFF79B6FF);
  static const grad2 = Color(0xFF4D8FEA);

  DateTime _focusedMonth = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;

  String _selectedTime = "09:00 AM";
  String _period = "Morning";

  // ---- utils ----
  String _monthTitle(DateTime d) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return "${months[d.month - 1]} ${d.year}";
  }

  String _dmy(DateTime d) {
    const monthsShort = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dd = d.day.toString().padLeft(2, '0');
    final m = monthsShort[d.month - 1];
    return "$dd $m";
  }

  void _prevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  // -------- Range helpers --------
  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isInRange(DateTime day) {
    if (_startDate == null || _endDate == null) return false;
    final d = _dateOnly(day);
    final s = _dateOnly(_startDate!);
    final e = _dateOnly(_endDate!);
    return (d.isAfter(s) && d.isBefore(e));
  }

  bool _isStart(DateTime day) =>
      _startDate != null && _isSameDay(_startDate!, day);
  bool _isEnd(DateTime day) => _endDate != null && _isSameDay(_endDate!, day);

  void _onPickDay(DateTime picked) {
    final d = _dateOnly(picked);
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = d;
        _endDate = null;
      } else {
        if (d.isBefore(_startDate!)) {
          _endDate = _startDate;
          _startDate = d;
        } else if (_isSameDay(d, _startDate!)) {
          _endDate = d;
        } else {
          _endDate = d;
        }
      }
    });
  }

  int get _daysSelected {
    if (_startDate == null || _endDate == null) return 1;
    // +1 علشان شامل يوم البداية والنهاية
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  int get _totalPrice => _daysSelected * widget.pricePerDay;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );

    // Sun-first grid
    final int firstWeekday = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    ).weekday; // 1..7 Mon..Sun
    final int leadingEmpty = firstWeekday % 7; // Sun->0

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context, {
            "start": _startDate,
            "end": _endDate,
            "time": _selectedTime,
            "period": _period,
          }),
        ),
        centerTitle: true,
        title: const Text(
          "Select Date",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      // ======= Bottom bar: shows total if range selected, otherwise /day =======
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgBottom],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Range label (only when both dates picked)
                    if (_startDate != null && _endDate != null) ...[
                      Text(
                        "${_dmy(_startDate!)} – ${_dmy(_endDate!)}  •  ${_daysSelected} day${_daysSelected > 1 ? 's' : ''}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ] else ...[
                      const Text(
                        "Total Price",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    Text(
                      _startDate != null && _endDate != null
                          ? "\$$_totalPrice"
                          : "\$${widget.pricePerDay} /day",
                      style: const TextStyle(
                        color: Color(0xFF88A9FF),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 160,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    /* Navigator.pop(context, {
                      "start": _startDate,
                      "end": _endDate,
                      "days": _daysSelected,
                      "total": _startDate != null && _endDate != null
                          ? _totalPrice
                          : widget.pricePerDay,
                      "time": _selectedTime,
                      "period": _period,
                    });*/
                   Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CheckoutPage(
            
            carImage: widget.carImage,  // ✅ هيتبعت مع الصفحة
          ),
        ),
      );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [grad1, grad2]),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: const Center(
                      child: Text(
                        "Book Now",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 255, 255, 255),
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

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgBottom],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان الشهر + أسهم داخل مربعات زرقاء
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _monthTitle(_focusedMonth),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    _chipArrow(Icons.arrow_back, _prevMonth),
                    const SizedBox(width: 10),
                    _chipArrow(Icons.arrow_forward, _nextMonth),
                  ],
                ),
                const SizedBox(height: 12),

                // اختصارات الأيام
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _Weekday('Su'),
                    _Weekday('Mo'),
                    _Weekday('Tu'),
                    _Weekday('We'),
                    _Weekday('Th'),
                    _Weekday('Fr'),
                    _Weekday('Sa'),
                  ],
                ),
                const SizedBox(height: 8),

                // شبكة التقويم
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: leadingEmpty + daysInMonth,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                        ),
                    itemBuilder: (context, index) {
                      if (index < leadingEmpty) {
                        return const SizedBox.shrink();
                      }
                      final day = index - leadingEmpty + 1;
                      final date = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month,
                        day,
                      );

                      final bool isStart = _isStart(date);
                      final bool isEnd = _isEnd(date);
                      final bool inRange = _isInRange(date);

                      BoxDecoration deco;
                      TextStyle txt;

                      if (isStart || isEnd) {
                        deco = BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [grad1, grad2],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white10),
                        );
                        txt = const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        );
                      } else if (inRange) {
                        deco = BoxDecoration(
                          color: Colors.white.withOpacity(.10),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white10),
                        );
                        txt = const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        );
                      } else {
                        deco = BoxDecoration(
                          color: Colors.white.withOpacity(.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white10),
                        );
                        txt = const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        );
                      }

                      return GestureDetector(
                        onTap: () => _onPickDay(date),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: deco,
                          child: Center(child: Text("$day", style: txt)),
                        ),
                      );
                    },
                  ),
                ),

                //const SizedBox(height: ),
                const Text(
                  "Pick Time",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Morning / Evening كمربعات بنفس ستايل التقويم
                Row(
                  children: [
                    _squareChip(
                      "Morning",
                      _period == "Morning",
                      () => setState(() => _period = "Morning"),
                    ),
                    const SizedBox(width: 12),
                    _squareChip(
                      "Evening",
                      _period == "Evening",
                      () => setState(() => _period = "Evening"),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // أوقات الساعة كمربعات
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final t in ["07:00", "09:00"])
                      _squareChip(
                        t,
                        _selectedTime == t,
                        () => setState(() => _selectedTime = t),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // أسهم الشهر داخل مربع أزرق
  Widget _chipArrow(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [grad1, grad2]),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  // مربع موحد للـ Morning/Evening وأوقات الساعة
  // مربع موحد للـ Morning/Evening وأوقات الساعة
  Widget _squareChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [grad1, grad2],
                ) // لو متعلم عليه يبقى أزرق
              : null,
          color: selected
              ? null
              : Colors.white.withOpacity(.06), // الافتراضي رمادي شفاف
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white, // النص دايمًا أبيض
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

// عنصر بسيط لاختصارات الأيام
class _Weekday extends StatelessWidget {
  final String text;
  const _Weekday(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
