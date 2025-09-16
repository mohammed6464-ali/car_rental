import 'package:flutter/material.dart';
import 'package:flutter_application_car_rentil/add_casrd.dart';
import 'package:flutter_application_car_rentil/home_page.dart'; // 👈 استدعاء صفحة الهوم

class CheckoutPage extends StatefulWidget {
  final String carImage; // 👈 نستقبل صورة العربية
  const CheckoutPage({super.key, required this.carImage});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const grad1 = Color(0xFF79B6FF);
  static const grad2 = Color(0xFF4D8FEA);
  static const bgTop = Color(0xFF121E3F);
  static const bgBottom = Color(0xFF0B1430);

  String _paymentMethod = "card"; // "card" أو "cod"

  // ===== Dialog =====
  void _showBookingDialog(BuildContext context, String carImage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF0B1430),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // زرار X
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false,
                      );
                    },
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),

                // صورة العربية
                Image.asset(
                  carImage,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),

                // النص
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Your Booking is ",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      TextSpan(
                        text: "Confirmed",
                        style: TextStyle(
                          color: Color(0xFF88A9FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // زرار Cancel
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [grad1, grad2],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: const Center(
                        child: Text(
                          "Done",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                // Debit/Credit card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Debit/Credit Card",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Example saved card
                      GestureDetector(
                        onTap: () {
                          setState(() => _paymentMethod = "card");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [grad1, grad2],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Visa Card",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 14)),
                              SizedBox(height: 8),
                              Text("•••• •••• •••• 2847",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text("Card Name",
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 13)),
                              Text("Mike Smith",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 8),
                              Text("Expires Date",
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 13)),
                              Text("04/30",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Add new card
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AddNewCardPage()),
                          );
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: Colors.white70, size: 20),
                            SizedBox(width: 6),
                            Text(
                              "Add new card",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Cash on Delivery
                GestureDetector(
                  onTap: () {
                    setState(() => _paymentMethod = "cod");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Cash on Delivery",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16)),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.8), width: 2),
                          ),
                          child: _paymentMethod == "cod"
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: grad2,
                                    ),
                                  ),
                                )
                              : null,
                        )
                      ],
                    ),
                  ),
                ),
                const Spacer(),

                // Pay Now button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      _showBookingDialog(context, widget.carImage);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [grad1, grad2]),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: const Center(
                        child: Text("Pay Now",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
