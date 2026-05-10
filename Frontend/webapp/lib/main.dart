import 'package:flutter/material.dart';
import 'Pages/Authorization/auth_page.dart';
import 'Pages/Authorization/login.dart';
import 'Pages/Authorization/signup.dart';
import 'Pages/home.dart';
import 'Pages/new_trip.dart';
import 'Pages/packinglist.dart';
import 'Pages/profile.dart';
import 'Pages/tripsection.dart';


void main() {
  runApp(const TraveloopApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traveloop',
      debugShowCheckedModeBanner: false,
      routes: {
        '/auth': (context) => const AuthPage(),
        '/login': (context) => const AuthPage(),
        '/signup': (context) => const AuthPage(),
        '/home': (context) => const HomePage(), 
        '/new_trip': (context) => const CreateTripScreen(),
        '/packing_list': (context) => const PackingChecklistScreen(),
        '/profile': (context) => const UserProfileScreen(),
        '/trip_section': (context) => const MyTripsScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD98B2C)),
        fontFamily: 'Segoe UI',
      ),
      home: const LoginPage(),
    );
  }
}

class AppColors {
  static const Color primary = Color.fromARGB(255, 79, 79, 175);
  static const Color accent = Color.fromARGB(255, 217, 139, 44);
  static const Color accentLight = Color(0xFFFFF0D9);
  static const Color teal = Color(0xFF2EC4B6);
  static const Color tealLight = Color(0xFFE0F7F5);
  static const Color bg = Color(0xFFF8F7F4);
  static const Color card = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF1A1A2E);
  static const Color textLight = Color(0xFF7B7B9A);
  static const Color border = Color(0xFFEAEAF0);
  static const Color danger = Color(0xFFE05C5C);
}
class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});
  @override State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _index = 0;

  final _screens = const [
    HomePage(),
    MyTripsScreen(),
    PackingChecklistScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
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
}

class Trip {
  final String id, name, description, coverEmoji;
  final DateTime startDate, endDate;
  final List<TripStop> stops;
  final double budget;
  bool isPublic;

  Trip({
    required this.id,
    required this.name,
    required this.description,
    required this.coverEmoji,
    required this.startDate,
    required this.endDate,
    required this.stops,
    required this.budget,
    this.isPublic = false,
  });

  int get durationDays => endDate.difference(startDate).inDays + 1;
  double get totalCost => stops.fold(0, (s, stop) => s + stop.totalCost);
}

class TripStop {
  final String id, cityName, countryName, emoji;
  final DateTime arrival, departure;
  final List<Activity> activities;

  TripStop({
    required this.id,
    required this.cityName,
    required this.countryName,
    required this.emoji,
    required this.arrival,
    required this.departure,
    required this.activities,
  });

  int get nights => departure.difference(arrival).inDays;
  double get totalCost => activities.fold(0, (s, a) => s + a.cost);
}

class Activity {
  final String id, name, category, description;
  final double cost;
  final int durationHours;
  bool isAdded;

  Activity({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.cost,
    required this.durationHours,
    this.isAdded = false,
  });
}

class ChecklistItem {
  final String id, name, category;
  bool isPacked;
  ChecklistItem({required this.id, required this.name, required this.category, this.isPacked = false});
}

class Note {
  final String id, title, content;
  final DateTime createdAt;
  Note({required this.id, required this.title, required this.content, required this.createdAt});
}

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  String userName = 'Alex Rivera';
  String userEmail = 'alex@example.com';
  String userAvatar = ' ';

  List<Trip> trips = [
    Trip(
      id: '1', name: 'Europe Dream Tour', description: 'Exploring the best of Western Europe',
      coverEmoji: '🗼', startDate: DateTime(2025, 6, 10), endDate: DateTime(2025, 6, 28),
      budget: 3500, isPublic: true,
      stops: [
        TripStop(id: 's1', cityName: 'Paris', countryName: 'France', emoji: '🗼',
          arrival: DateTime(2025, 6, 10), departure: DateTime(2025, 6, 14),
          activities: [
            Activity(id: 'a1', name: 'Eiffel Tower', category: 'Sightseeing', description: 'Visit the iconic iron tower', cost: 26, durationHours: 3, isAdded: true),
            Activity(id: 'a2', name: 'Louvre Museum', category: 'Culture', description: 'World\'s largest art museum', cost: 22, durationHours: 4, isAdded: true),
            Activity(id: 'a3', name: 'Seine River Cruise', category: 'Adventure', description: 'Scenic cruise along the Seine', cost: 15, durationHours: 1, isAdded: true),
          ]),
        TripStop(id: 's2', cityName: 'Amsterdam', countryName: 'Netherlands', emoji: '🚲',
          arrival: DateTime(2025, 6, 14), departure: DateTime(2025, 6, 18),
          activities: [
            Activity(id: 'a4', name: 'Anne Frank House', category: 'Culture', description: 'Historic wartime hiding place', cost: 16, durationHours: 2, isAdded: true),
            Activity(id: 'a5', name: 'Canal Bike Tour', category: 'Adventure', description: 'Pedal through Amsterdam canals', cost: 25, durationHours: 2, isAdded: true),
          ]),
        TripStop(id: 's3', cityName: 'Rome', countryName: 'Italy', emoji: '🏛️',
          arrival: DateTime(2025, 6, 18), departure: DateTime(2025, 6, 22),
          activities: [
            Activity(id: 'a6', name: 'Colosseum Tour', category: 'Sightseeing', description: 'Ancient Roman amphitheatre', cost: 18, durationHours: 3, isAdded: true),
            Activity(id: 'a7', name: 'Vatican Museums', category: 'Culture', description: 'Sistine Chapel & papal collections', cost: 20, durationHours: 4, isAdded: true),
          ]),
      ],
    ),
    Trip(
      id: '2', name: 'Japan Adventure', description: 'Cherry blossoms and neon lights',
      coverEmoji: '🗾', startDate: DateTime(2025, 9, 1), endDate: DateTime(2025, 9, 14),
      budget: 4200, isPublic: false,
      stops: [
        TripStop(id: 's4', cityName: 'Tokyo', countryName: 'Japan', emoji: '🗼',
          arrival: DateTime(2025, 9, 1), departure: DateTime(2025, 9, 6),
          activities: [
            Activity(id: 'a8', name: 'Shibuya Crossing', category: 'Sightseeing', description: 'World\'s busiest pedestrian crossing', cost: 0, durationHours: 1, isAdded: true),
            Activity(id: 'a9', name: 'Teamlab Borderless', category: 'Culture', description: 'Immersive digital art museum', cost: 32, durationHours: 3, isAdded: true),
          ]),
        TripStop(id: 's5', cityName: 'Kyoto', countryName: 'Japan', emoji: '⛩️',
          arrival: DateTime(2025, 9, 6), departure: DateTime(2025, 9, 10),
          activities: [
            Activity(id: 'a10', name: 'Fushimi Inari', category: 'Sightseeing', description: 'Thousands of torii gates', cost: 0, durationHours: 3, isAdded: true),
          ]),
      ],
    ),
  ];



  List<ChecklistItem> checklistItems = [
    ChecklistItem(id: 'c1', name: 'Passport', category: 'Documents', isPacked: true),
    ChecklistItem(id: 'c2', name: 'Travel Insurance', category: 'Documents', isPacked: true),
    ChecklistItem(id: 'c3', name: 'Flight Tickets', category: 'Documents', isPacked: false),
    ChecklistItem(id: 'c4', name: 'T-Shirts (5)', category: 'Clothing', isPacked: false),
    ChecklistItem(id: 'c5', name: 'Jeans (2)', category: 'Clothing', isPacked: false),
    ChecklistItem(id: 'c6', name: 'Phone Charger', category: 'Electronics', isPacked: true),
    ChecklistItem(id: 'c7', name: 'Power Bank', category: 'Electronics', isPacked: false),
    ChecklistItem(id: 'c8', name: 'Camera', category: 'Electronics', isPacked: false),
  ];

  List<Note> notes = [
    Note(id: 'n1', title: 'Hotel Check-in Paris', content: 'Hotel Le Marais, Check-in after 3pm. Confirmation: #PRS2025', createdAt: DateTime(2025, 5, 1)),
    Note(id: 'n2', title: 'Must-try restaurants in Rome', content: 'Da Enzo al 29 (Trastevere), Roscioli Salumeria, Supplì Roma', createdAt: DateTime(2025, 5, 3)),
  ];

  void login() { isLoggedIn = true; notifyListeners(); }
  void logout() { isLoggedIn = false; notifyListeners(); }

  void addTrip(Trip trip) { trips.add(trip); notifyListeners(); }
  void deleteTrip(String id) { trips.removeWhere((t) => t.id == id); notifyListeners(); }
  void toggleTripPublic(String id) {
    final t = trips.firstWhere((t) => t.id == id);
    t.isPublic = !t.isPublic;
    notifyListeners();
  }

  void togglePackedItem(String id) {
    final item = checklistItems.firstWhere((i) => i.id == id);
    item.isPacked = !item.isPacked;
    notifyListeners();
  }

  void addChecklistItem(String name, String category) {
    checklistItems.add(ChecklistItem(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, category: category));
    notifyListeners();
  }

  void addNote(String title, String content) {
    notes.add(Note(id: DateTime.now().millisecondsSinceEpoch.toString(), title: title, content: content, createdAt: DateTime.now()));
    notifyListeners();
  }

  void deleteNote(String id) { notes.removeWhere((n) => n.id == id); notifyListeners(); }
}

// ─── Global State ─────────────────────────────────────────────────────────────
final appState = AppState();

// ─── App Root ─────────────────────────────────────────────────────────────────
class TraveloopApp extends StatelessWidget {
  const TraveloopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'Traveloop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Georgia',
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),
            scaffoldBackgroundColor: AppColors.bg,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: AppColors.text),
              titleTextStyle: TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
            ),
          ),
          home: appState.isLoggedIn ? const MainNavScreen() : const LoginPage(),
          routes: {
            '/auth': (context) => const AuthPage(),
            '/login': (context) => const LoginPage(),
            '/signup': (context) => const SignupPage(),
            '/home': (context) => const MainNavScreen(),
            '/new_trip': (context) => const CreateTripScreen(),
          },
        );
      },
    );
  }
}

// ─── Notifications Screen ─────────────────────────────────────────────────────
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _notif('Trip reminder', 'Your Paris trip starts in 7 days!', '2h ago', Icons.airplane_ticket, AppColors.accent),
          _notif('Budget alert', 'Japan trip is at 75% of budget', '1d ago', Icons.attach_money, AppColors.danger),
          _notif('New follower', 'Sarah started following your trips', '2d ago', Icons.person_add, AppColors.teal),
          _notif('Trip liked', 'Your Europe tour got 12 likes', '3d ago', Icons.favorite, AppColors.accent),
        ],
      ),
    );
  }

  Widget _notif(String title, String body, String time, IconData icon, Color color) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
    child: Row(children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        Text(body, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
      ])),
      Text(time, style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
    ]),
  );
}
