import 'package:flutter/material.dart';
import '../main.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({Key? key}) : super(key: key);

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final List<Map<String, String>> _suggestions = [
    {'title': 'Beach', 'subtitle': 'Relax by the sea', 'icon': '🏖'},
    {'title': 'Mountain', 'subtitle': 'Hike the trails', 'icon': '⛰'},
    {'title': 'City', 'subtitle': 'Explore local streets', 'icon': '🏙'},
    {'title': 'Food', 'subtitle': 'Taste new flavors', 'icon': '🍲'},
    {'title': 'Culture', 'subtitle': 'Visit museums', 'icon': '🏛'},
    {'title': 'Adventure', 'subtitle': 'Try new sports', 'icon': '🚣'},
  ];

  @override
  void dispose() {
    _destinationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar:AppBar(
        backgroundColor: const Color.fromARGB(255, 119, 119, 232),
        elevation: 1,
        title: const Text('Traveloop', style: TextStyle(color: AppColors.accentLight, fontSize: 26),  ),
        actions: const [
          SizedBox(width: 24),
          Icon(Icons.notifications_none, color: AppColors.accentLight),
          SizedBox(width: 8),
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.account_circle,
              color: AppColors.accentLight,
              size: 28,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create your next adventure',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fill in the details and discover great places to visit.',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip details',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: 'Destination',
                    controller: _destinationController,
                    hintText: 'Enter a city or country',
                    icon: Icons.place,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    label: 'Start date',
                    controller: _startDateController,
                    hintText: 'MM/DD/YYYY',
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    label: 'End date',
                    controller: _endDateController,
                    hintText: 'MM/DD/YYYY',
                    icon: Icons.calendar_month,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    label: 'Notes',
                    controller: _notesController,
                    hintText: 'Add any travel preferences',
                    icon: Icons.notes,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                _buildPill('Solo'),
                const SizedBox(width: 10),
                _buildPill('Couple'),
                const SizedBox(width: 10),
                _buildPill('Family'),
              ],
            ),
            const SizedBox(height: 26),
            Text(
              'Suggestions',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _suggestions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                final item = _suggestions[index];
                return Container(
                  constraints: const BoxConstraints(minHeight: 120, minWidth: 150, maxHeight: 220, maxWidth: 260),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['icon']!,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const Spacer(),
                      Text(
                        item['title']!,
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['subtitle']!,
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                ),
                child: const Text('Save itinerary'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: NavigationBar(
          selectedIndex: 1,
          onDestinationSelected: (i) {
            if (i == 0) Navigator.pushNamed(context, '/home');
            else if (i == 2) Navigator.pushNamed(context, '/packing_list');
            // Add navigation for other indices if needed
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.text,
            fontSize: isPhone ? 13.0 : 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textLight, size: 20),
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.textLight, fontSize: isPhone ? 13.0 : 14.0),
            filled: true,
            fillColor: AppColors.bg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.accent),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
          style: TextStyle(
            color: AppColors.text,
            fontSize: isPhone ? 13.0 : 14.0,
          ),
        ),
      ],
    );
  }

  Widget _buildPill(String label) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isPhone ? 12 : 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.text,
          fontSize: isPhone ? 13.0 : 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
