import 'package:flutter/material.dart';
import 'package:webapp/Pages/root.dart';
import '../main.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      alignment: Alignment.center,
                      child: Text(appState.userAvatar, style: const TextStyle(fontSize: 36)),
                    ),
                    const SizedBox(height: 10),
                    Text(appState.userName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    Text(appState.userEmail, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Stats
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                      _stat('${appState.trips.length}', 'Trips'),
                      _divider(),
                      _stat('${appState.trips.fold(0, (s, t) => s + t.stops.length)}', 'Cities'),
                      _divider(),
                      _stat('${appState.trips.where((t) => t.isPublic).length}', 'Public'),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  _section([
                    _tile(Icons.person_outline, 'Edit Profile', () {}),
                    _tile(Icons.language, 'Language', () {}),
                    _tile(Icons.favorite_outline, 'Saved Destinations', () {}),
                    _tile(Icons.notifications_outlined, 'Notifications', () {}),
                  ]),
                  const SizedBox(height: 12),
                  _section([
                    _tile(Icons.admin_panel_settings_outlined, 'Admin Dashboard', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()))),
                    _tile(Icons.help_outline, 'Help & Support', () {}),
                    _tile(Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
                  ]),
                  const SizedBox(height: 12),
                  _section([
                    _tile(Icons.logout, 'Sign Out', () => Navigator.pushNamed(context, '/login'), color: AppColors.danger),
                    _tile(Icons.delete_forever_outlined, 'Delete Account', () {}, color: AppColors.danger),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: NavigationBar(
          selectedIndex: 3,
          onDestinationSelected: (i) {
            if (i == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (i == 1) {
              Navigator.pushReplacementNamed(context, '/trip_section');
            } else if (i == 2) {
              Navigator.pushReplacementNamed(context, '/packing_list');
            }

            // i == 2 is current page (Packing)
            // i == 3 (Profile) is not yet implemented
          },
          backgroundColor: Colors.white,
          elevation: 0,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.luggage_outlined), selectedIcon: Icon(Icons.luggage), label: 'My Trips'),
            NavigationDestination(icon: Icon(Icons.checklist_outlined), selectedIcon: Icon(Icons.checklist), label: 'Packing'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label) => Column(children: [
    Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.text)),
    Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
  ]);

  Widget _divider() => Container(width: 1, height: 36, color: AppColors.border);

  Widget _section(List<Widget> tiles) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
    child: Column(children: tiles),
  );

  Widget _tile(IconData icon, String label, VoidCallback onTap, {Color? color}) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border.withOpacity(0.5)))),
      child: Row(children: [
        Icon(icon, size: 20, color: color ?? AppColors.text),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: color ?? AppColors.text)),
        const Spacer(),
        Icon(Icons.chevron_right, size: 18, color: color ?? AppColors.textLight),
      ]),
    ),
  );
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard'), backgroundColor: AppColors.primary,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Georgia')),
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI row
            Row(children: [
              _kpi('Total Users', '1,284', Icons.people, AppColors.teal),
              const SizedBox(width: 10),
              _kpi('Trips Created', '4,730', Icons.luggage, AppColors.accent),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              _kpi('Active Today', '138', Icons.online_prediction, AppColors.primary),
              const SizedBox(width: 10),
              _kpi('Revenue', '\$12.4k', Icons.bar_chart, const Color(0xFF9C6FDE)),
            ]),
            const SizedBox(height: 20),

            const Text('Top Cities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            ...[ ['Paris 🗼', 0.87], ['Tokyo 🗾', 0.75], ['Bali 🌴', 0.68], ['Rome 🏛️', 0.61], ['NY 🗽', 0.58] ]
              .map((d) => _barRow(d[0] as String, d[1] as double)),

            const SizedBox(height: 20),
            const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            ...[
              ['New user signed up', '2m ago'],
              ['Trip "Bali Escape" created', '15m ago'],
              ['User exported itinerary', '1h ago'],
              ['5 new public trips shared', '3h ago'],
            ].map((e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Expanded(child: Text(e[0], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                Text(e[1], style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
              ]),
            )),
          ],
        ),
      ),
    );
  }

  Widget _kpi(String label, String value, IconData icon, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.text)),
          Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
        ]),
      ]),
    ),
  );

  Widget _barRow(String city, double pct) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(children: [
      SizedBox(width: 80, child: Text(city, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
      const SizedBox(width: 8),
      Expanded(child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(value: pct, minHeight: 10, backgroundColor: AppColors.bg, valueColor: const AlwaysStoppedAnimation(AppColors.accent)),
      )),
      const SizedBox(width: 8),
      Text('${(pct * 100).toInt()}%', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
    ]),
  );
}