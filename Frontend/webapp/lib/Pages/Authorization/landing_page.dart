import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traveloop'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.circle_outlined), // Profile icon placeholder
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Main Landing Page (Screen 3)', style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 8),
            // Banner Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white54),
              ),
              alignment: Alignment.center,
              child: const Text('Banner Image', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 16),
            // Search and Filters Bar
            Row(
              children: [
                const Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Search bar ....'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildWireframeButton('Group by'),
                const SizedBox(width: 8),
                _buildWireframeButton('Filter'),
                const SizedBox(width: 8),
                _buildWireframeButton('Sort by...'),
              ],
            ),
            const SizedBox(height: 24),
            // Top Regional Selections
            const Text('Top Regional Selections', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // Previous Trips
            const Text('Previous Trips', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: _buildWireframeButton('+ Plan a trip'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWireframeButton(String text) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white54),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(0, 40),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}