import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _searchAnimationController;
  late Animation<double> _searchScaleAnimation;
  bool _isSearchFocused = false;
  
  String _firstName = 'Traveler';
  bool _isLoadingProfile = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get token passed from login page
    final token = ModalRoute.of(context)?.settings.arguments as String?;
    if (token != null && _isLoadingProfile) {
      _fetchProfile(token);
    } else {
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _fetchProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/auth/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          _firstName = data['user']['first_name'] ?? 'Traveler';
        });
      }
    } catch (e) {
      print('Error fetching profile: $e');
    } finally {
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _searchAnimationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Welcome back,', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      Text(_firstName, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Row(
                    children: [
                      _buildStat('Trips', appState.trips.length.toString(), AppColors.primary),
                      const SizedBox(width: 12),
                      _buildStat('Cities', '8', AppColors.teal),
                      const SizedBox(width: 12),
                      _buildStat('Saved', '12', AppColors.accent),
                    ],
                  ),
                  const SizedBox(height: 32),

                  const Text('Upcoming Adventures', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  
                  // Featured Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(16)),
                              child: const Text('🗼', style: TextStyle(fontSize: 32)),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Paris Escape', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                                Text('Oct 12 - Oct 24 · 12 Days', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TLButton(label: 'View Itinerary', onTap: () {}),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  const Text('Curated for You', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 280,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _curatedCard('Manali, India', '4.9', '₹45,000', 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=600&q=80'),
                        _curatedCard('Ubud, Bali', '4.8', '₹85,000', 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=600&q=80'),
                        _curatedCard('Paris, France', '4.9', '₹1,40,000', 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=600&q=80'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  const Text('Explore Regions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryCard('Islands', '🏝️'),
                        _buildCategoryCard('Mountains', '🏔️'),
                        _buildCategoryCard('Cities', '🏙️'),
                        _buildCategoryCard('Forest', '🌲'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Space for nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    ),
  );

  Widget _buildCategoryCard(String label, String emoji) => Container(
    width: 140,
    margin: const EdgeInsets.only(right: 12),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 40)),
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
      ],
    ),
  );

  Widget _curatedCard(String title, String rating, String price, String imgUrl) => Container(
    width: 260,
    margin: const EdgeInsets.only(right: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: AppColors.border),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: Stack(
            children: [
              Image.network(imgUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(rating, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ]),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(price, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 16)),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.text,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSelectionCard(int index) {
    final labels = ['Lake', 'Mountain', 'Beach', 'Urban', 'Forest'];
    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: AppColors.tealLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.place,
              color: AppColors.teal,
              size: 32,
            ),
          ),
          const Spacer(),
          Text(
            labels[index % labels.length],
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Popular',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(int index) {
    final titles = ['Seoul Escape', 'Sicily Sunset', 'Kyoto Walk', 'Morocco Market'];
    final subtitles = ['3 days • 2 guests', '5 days • 4 guests', '4 days • 2 guests', '6 days • 3 guests'];
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.tealLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                Icons.flight_takeoff,
                size: 48,
                color: AppColors.teal,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            titles[index % titles.length],
            style: TextStyle(
              color: AppColors.text,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitles[index % subtitles.length],
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'View',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}