import 'package:flutter/material.dart';
import 'package:flutter_application_car_rentil/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const bgTop = Color(0xFF121E3F);
  static const bgBottom = Color(0xFF0B1430);
  static const grad1 = Color(0xFF79B6FF);
  static const grad2 = Color(0xFF4D8FEA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context), // يرجع للخلف
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
                // ===== Header (صورة واسم) =====
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage("assets/img/profile.png"), // 👈 حط صورتك هنا
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "William Mike",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: Navigate to edit profile
                          },
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: Color(0xFF79B6FF),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white70),
                      onPressed: () {
                        // TODO: Navigate to edit profile
                      },
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white24),

                // ===== 3 كروت =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _InfoCard(icon: Icons.credit_card, label: "License"),
                    _InfoCard(icon: Icons.wallet, label: "Passport"),
                    _InfoCard(icon: Icons.article, label: "Contract"),
                  ],
                ),
                const SizedBox(height: 30),

                // ===== القوائم =====
                const _ListItem(
                    icon: Icons.person, text: "My Profile"),
                const _ListItem(
                    icon: Icons.calendar_month, text: "My Bookings"),
                const _ListItem(
                    icon: Icons.settings, text: "Settings"),

                const Spacer(),

                // ===== زرار Logout =====
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.white70),
                      SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
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

// === Widget: كارت صغير (License, Passport, Contract) ===
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue[300]),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          )
        ],
      ),
    );
  }
}

// === Widget: عنصر من الليست (My Profile, My Bookings, Settings) ===
class _ListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ListItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white70),
          title: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          trailing: const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.white54),
          onTap: () {},
        ),
        const Divider(color: Colors.white12, height: 1),
      ],
    );
  }
}
