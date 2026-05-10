import 'package:flutter/material.dart';
import 'package:webapp/Pages/root.dart';
import 'new_trip.dart';
import '../main.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Trips'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.accent, size: 28),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateTripScreen())),
              ),
            ],
          ),
          body: appState.trips.isEmpty
            ? const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🗺️', style: TextStyle(fontSize: 60)),
                  SizedBox(height: 16),
                  Text('No trips yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text)),
                  Text('Tap + to plan your first adventure!', style: TextStyle(color: AppColors.textLight)),
                ],
              ))
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: appState.trips.length,
                itemBuilder: (context, i) {
                  final trip = appState.trips[i];
                  return TripCard(
                    trip: trip,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TripDetailScreen(trip: trip))),
                    onDelete: () => appState.deleteTrip(trip.id),
                  );
                },
              ),
          ),
        );
      },
    );
  }
}

// ─── Trip Detail / Itinerary View ─────────────────────────────────────────────
class TripDetailScreen extends StatefulWidget {
  final Trip trip;
  const TripDetailScreen({super.key, required this.trip});
  @override State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                child: Stack(
                  children: [
                    Positioned(right: -30, top: -30, child: Text(trip.coverEmoji, style: const TextStyle(fontSize: 140))),
                    Positioned(left: 20, bottom: 50, child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trip.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                        Text(trip.description, style: const TextStyle(color: Colors.white60, fontSize: 13)),
                        const SizedBox(height: 8),
                        Row(children: [
                          _tag('${trip.stops.length} cities'),
                          const SizedBox(width: 8),
                          _tag('${trip.durationDays} days'),
                          const SizedBox(width: 8),
                          _tag('\$${trip.budget.toInt()} budget'),
                        ]),
                      ],
                    )),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabs,
              indicatorColor: AppColors.accent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: const [Tab(text: 'Itinerary'), Tab(text: 'Budget'), Tab(text: 'Notes'), Tab(text: 'Share')],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabs,
          children: [
            _ItineraryTab(trip: trip),
            _BudgetTab(trip: trip),
            _NotesTab(trip: trip),
            _ShareTab(trip: trip),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ItineraryBuilderScreen(trip: trip))),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text('Edit Itinerary', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }
  
  Widget _tag(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
    child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
  );
}

class _ItineraryTab extends StatelessWidget {
  final Trip trip;
  const _ItineraryTab({required this.trip});

  @override
  Widget build(BuildContext context) {
    if (trip.stops.isEmpty) {
      return const Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🗺️', style: TextStyle(fontSize: 50)),
          SizedBox(height: 12),
          Text('No stops yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text)),
          Text('Edit the itinerary to add cities', style: TextStyle(color: AppColors.textLight)),
        ],
      ));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: trip.stops.length,
      itemBuilder: (context, i) {
        final stop = trip.stops[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: AppColors.accentLight, borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Text(stop.emoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(stop.cityName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.text)),
                Text('${stop.countryName} · ${stop.nights} nights', style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
              ]),
              const Spacer(),
              Text('\$${stop.totalCost.toInt()}', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 10),
            ...stop.activities.map((act) => Container(
              margin: const EdgeInsets.only(bottom: 8, left: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(children: [
                _categoryIcon(act.category),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(act.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    Text('${act.durationHours}h · ${act.category}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                  ],
                )),
                Text(act.cost == 0 ? 'Free' : '\$${act.cost.toInt()}',
                  style: TextStyle(fontWeight: FontWeight.w700, color: act.cost == 0 ? AppColors.teal : AppColors.text, fontSize: 13)),
              ]),
            )),
            if (i < trip.stops.length - 1) Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(children: [
                const SizedBox(width: 19),
                Column(children: List.generate(4, (i) => Container(width: 2, height: 6, margin: const EdgeInsets.only(bottom: 4), color: AppColors.accent.withOpacity(0.4)))),
                const SizedBox(width: 12),
                const Icon(Icons.airplanemode_active, color: AppColors.accent, size: 20),
              ]),
            ),
          ],
        );
      },
    );
  }

Widget _categoryIcon(String cat) {
    final icons = {'Sightseeing': Icons.photo_camera, 'Culture': Icons.museum, 'Adventure': Icons.hiking, 'Food': Icons.restaurant};
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(8)),
      child: Icon(icons[cat] ?? Icons.star, size: 14, color: AppColors.teal),
    );
  }
}

class _BudgetTab extends StatelessWidget {
  final Trip trip;
  const _BudgetTab({required this.trip});

  @override
  Widget build(BuildContext context) {
    final spent = trip.totalCost;
    final remaining = trip.budget - spent;
    final pct = (spent / trip.budget).clamp(0.0, 1.0);

    final byCategory = <String, double>{};
    for (final stop in trip.stops) {
      for (final act in stop.activities) {
        byCategory[act.category] = (byCategory[act.category] ?? 0) + act.cost;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _stat('Budget', '\$${trip.budget.toInt()}', Colors.white),
                _stat('Spent', '\$${spent.toInt()}', AppColors.accent),
                _stat('Remaining', '\$${remaining.toInt()}', remaining >= 0 ? AppColors.teal : AppColors.danger),
              ]),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: pct, minHeight: 10,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation(pct > 0.9 ? AppColors.danger : AppColors.accent),
                ),
              ),
              const SizedBox(height: 8),
              Text('${(pct * 100).toInt()}% of budget used', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ]),
          ),
          const SizedBox(height: 20),

          const Text('Breakdown by Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ...byCategory.entries.map((e) {
            final catPct = e.value / spent;
            final colors = [AppColors.accent, AppColors.teal, AppColors.primary, AppColors.danger, const Color(0xFF9C6FDE)];
            final color = colors[byCategory.keys.toList().indexOf(e.key) % colors.length];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(e.key, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: catPct.isNaN ? 0 : catPct, minHeight: 6, backgroundColor: AppColors.bg, valueColor: AlwaysStoppedAnimation(color)),
                  ),
                ])),
                const SizedBox(width: 10),
                Text('\$${e.value.toInt()}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ]),
            );
          }),
          const SizedBox(height: 20),

          // Per city
          const Text('Cost per City', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ...trip.stops.map((stop) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Text(stop.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(child: Text(stop.cityName, style: const TextStyle(fontWeight: FontWeight.w700))),
              Text('\$${stop.totalCost.toInt()}', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.accent)),
            ]),
          )),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, Color color) => Column(children: [
    Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900)),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
  ]);
}

class _NotesTab extends StatelessWidget {
  final Trip trip;
  const _NotesTab({required this.trip});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.bg,
          body: appState.notes.isEmpty
            ? const Center(child: Text('No notes yet', style: TextStyle(color: AppColors.textLight)))
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: appState.notes.length,
                itemBuilder: (context, i) {
                  final note = appState.notes[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(note.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(note.content, style: const TextStyle(color: AppColors.textLight, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Text('${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}', style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
                      ])),
                      GestureDetector(
                        onTap: () => appState.deleteNote(note.id),
                        child: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                      ),
                    ]),
                  );
                },
              ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.accent,
            onPressed: () => _showAddNote(context),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  void _showAddNote(BuildContext context) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('Add Note', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          TLTextField(hint: 'Note title...', label: 'Title', controller: titleCtrl),
          const SizedBox(height: 12),
          TLTextField(hint: 'Write your note...', label: 'Content', controller: contentCtrl),
          const SizedBox(height: 16),
          TLButton(label: 'Save Note', onTap: () {
            appState.addNote(titleCtrl.text, contentCtrl.text);
            Navigator.pop(context);
          }),
        ]),
      ),
    );
  }
}

class _ShareTab extends StatelessWidget {
  final Trip trip;
  const _ShareTab({required this.trip});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: trip.isPublic ? AppColors.tealLight : AppColors.bg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: trip.isPublic ? AppColors.teal : AppColors.border),
                ),
                child: Row(children: [
                  Icon(trip.isPublic ? Icons.public : Icons.lock_outline,
                    color: trip.isPublic ? AppColors.teal : AppColors.textLight, size: 28),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(trip.isPublic ? 'Trip is Public' : 'Trip is Private',
                      style: TextStyle(fontWeight: FontWeight.w800, color: trip.isPublic ? AppColors.teal : AppColors.text)),
                    Text(trip.isPublic ? 'Anyone with the link can view' : 'Only you can see this trip',
                      style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                  ])),
                  Switch(
                    value: trip.isPublic,
                    onChanged: (_) => appState.toggleTripPublic(trip.id),
                    activeColor: AppColors.teal,
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              if (trip.isPublic) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: Row(children: [
                    const Icon(Icons.link, color: AppColors.textLight, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text('traveloop.app/trip/${trip.id}', style: const TextStyle(color: AppColors.text, fontSize: 13))),
                    const Icon(Icons.copy, color: AppColors.accent, size: 18),
                  ]),
                ),
                const SizedBox(height: 12),
                const Text('Share via', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  _shareBtn('WhatsApp', '💬', const Color(0xFF25D366)),
                  _shareBtn('Twitter', '🐦', const Color(0xFF1DA1F2)),
                  _shareBtn('Instagram', '📸', const Color(0xFFE1306C)),
                  _shareBtn('Copy', '🔗', AppColors.accent),
                ]),
              ],
            ],
          ),
        );
      },
    );
  }


  Widget _shareBtn(String label, String emoji, Color color) => Column(
    children: [
      Container(
        width: 52, height: 52,
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
    ],
  );
}

class ItineraryBuilderScreen extends StatelessWidget {
  final Trip trip;
  const ItineraryBuilderScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Build: ${trip.name}')),
      body: Column(
        children: [
          Expanded(
            child: trip.stops.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('🗺️', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 16),
                  const Text('Add your first stop', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TLButton(label: 'Search Cities', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CitySearchScreen()))),
                ]))
              : ReorderableListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: trip.stops.length,
                  onReorder: (oldIndex, newIndex) {},
                  itemBuilder: (context, i) {
                    final stop = trip.stops[i];
                    return Container(
                      key: ValueKey(stop.id),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                      child: Row(children: [
                        Text(stop.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(stop.cityName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          Text('${stop.nights} nights · ${stop.activities.length} activities', style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
                        ])),
                        const Icon(Icons.drag_handle, color: AppColors.textLight),
                      ]),
                    );
                  },
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Expanded(child: TLButton(label: 'Add City', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CitySearchScreen())), icon: Icons.add_location_outlined)),
              const SizedBox(width: 12),
              Expanded(child: TLButton(label: 'Add Activity', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivitySearchScreen())), icon: Icons.local_activity_outlined, color: AppColors.teal)),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─── 7. City Search Screen ────────────────────────────────────────────────────
class CitySearchScreen extends StatefulWidget {
  const CitySearchScreen({super.key});
  @override State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final searchCtrl = TextEditingController();
  String query = '';
  String filter = 'All';

  static final List<Map<String, dynamic>> _cities = [
    {'emoji': '🗼', 'name': 'Paris', 'country': 'France', 'region': 'Europe', 'cost': '\$\$\$', 'rating': 4.9, 'desc': 'City of Light and Love'},
    {'emoji': '🏯', 'name': 'Kyoto', 'country': 'Japan', 'region': 'Asia', 'cost': '\$\$', 'rating': 4.8, 'desc': 'Ancient temples & geishas'},
    {'emoji': '🗽', 'name': 'New York', 'country': 'USA', 'region': 'Americas', 'cost': '\$\$\$\$', 'rating': 4.7, 'desc': 'The city that never sleeps'},
    {'emoji': '🏰', 'name': 'Prague', 'country': 'Czech Republic', 'region': 'Europe', 'cost': '\$\$', 'rating': 4.6, 'desc': 'Medieval fairytale city'},
    {'emoji': '🌴', 'name': 'Bali', 'country': 'Indonesia', 'region': 'Asia', 'cost': '\$', 'rating': 4.8, 'desc': 'Island of the Gods'},
    {'emoji': '🏛️', 'name': 'Rome', 'country': 'Italy', 'region': 'Europe', 'cost': '\$\$\$', 'rating': 4.7, 'desc': 'Eternal city of history'},
    {'emoji': '🚲', 'name': 'Amsterdam', 'country': 'Netherlands', 'region': 'Europe', 'cost': '\$\$\$', 'rating': 4.5, 'desc': 'Canals and culture'},
    {'emoji': '🦁', 'name': 'Nairobi', 'country': 'Kenya', 'region': 'Africa', 'cost': '\$\$', 'rating': 4.4, 'desc': 'Gateway to Safari'},
    {'emoji': '🦜', 'name': 'Rio', 'country': 'Brazil', 'region': 'Americas', 'cost': '\$\$', 'rating': 4.6, 'desc': 'Carnival and beaches'},
    {'emoji': '🏙️', 'name': 'Singapore', 'country': 'Singapore', 'region': 'Asia', 'cost': '\$\$\$', 'rating': 4.8, 'desc': 'Futuristic garden city'},
  ];

  final regions = ['All', 'Europe', 'Asia', 'Americas', 'Africa'];

  @override
  Widget build(BuildContext context) {
    final filtered = _cities.where((c) {
      final matchQ = query.isEmpty || c['name'].toString().toLowerCase().contains(query.toLowerCase());
      final matchF = filter == 'All' || c['region'] == filter;
      return matchQ && matchF;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Find a City')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: searchCtrl,
              onChanged: (v) => setState(() => query = v),
              decoration: InputDecoration(
                hintText: 'Search cities, countries...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accent, width: 2)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: regions.length,
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => setState(() => filter = regions[i]),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: filter == regions[i] ? AppColors.accent : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: filter == regions[i] ? AppColors.accent : AppColors.border),
                  ),
                  child: Text(regions[i], style: TextStyle(color: filter == regions[i] ? Colors.white : AppColors.text, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final city = filtered[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                  child: Row(children: [
                    Text(city['emoji'], style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(city['name'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(city['cost'], style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
                      ]),
                      Text('${city['country']} · ⭐ ${city['rating']}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(city['desc'], style: const TextStyle(fontSize: 12, color: AppColors.text)),
                    ])),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${city['name']} added to trip!'),
                          backgroundColor: AppColors.teal,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.accentLight, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.add, color: AppColors.accent, size: 20),
                      ),
                    ),
                  ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ActivitySearchScreen extends StatefulWidget {
  const ActivitySearchScreen({super.key});
  @override State<ActivitySearchScreen> createState() => _ActivitySearchScreenState();
}

class _ActivitySearchScreenState extends State<ActivitySearchScreen> {
  String filter = 'All';
  final categories = ['All', 'Sightseeing', 'Culture', 'Adventure', 'Food', 'Nature'];

  static final List<Activity> _activities = [
    Activity(id: 'sa1', name: 'City Walking Tour', category: 'Sightseeing', description: 'Explore the historic city center on foot with a local guide', cost: 15, durationHours: 3),
    Activity(id: 'sa2', name: 'Cooking Class', category: 'Food', description: 'Learn to cook traditional local dishes', cost: 65, durationHours: 3),
    Activity(id: 'sa3', name: 'Kayaking Adventure', category: 'Adventure', description: 'Paddle through scenic waterways', cost: 45, durationHours: 4),
    Activity(id: 'sa4', name: 'Art Museum Visit', category: 'Culture', description: 'Explore centuries of masterpieces', cost: 18, durationHours: 3),
    Activity(id: 'sa5', name: 'Sunset Boat Tour', category: 'Sightseeing', description: 'Watch the sunset from the water', cost: 35, durationHours: 2),
    Activity(id: 'sa6', name: 'Street Food Tour', category: 'Food', description: 'Sample authentic local street food', cost: 30, durationHours: 2),
    Activity(id: 'sa7', name: 'Hiking Trail', category: 'Nature', description: 'Scenic hike through national park', cost: 0, durationHours: 5),
    Activity(id: 'sa8', name: 'Wine Tasting', category: 'Food', description: 'Taste premium local wines at vineyard', cost: 50, durationHours: 2),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = filter == 'All' ? _activities : _activities.where((a) => a.category == filter).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Activities')),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => setState(() => filter = categories[i]),
                child: Container(
                  margin: const EdgeInsets.only(right: 8, top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: filter == categories[i] ? AppColors.teal : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: filter == categories[i] ? AppColors.teal : AppColors.border),
                  ),
                  child: Text(categories[i], style: TextStyle(color: filter == categories[i] ? Colors.white : AppColors.text, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final act = filtered[i];
                return StatefulBuilder(
                  builder: (context, setS) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: act.isAdded ? AppColors.tealLight : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: act.isAdded ? AppColors.teal : AppColors.border),
                    ),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.accentLight, borderRadius: BorderRadius.circular(12)),
                        child: Icon(_categoryIcon(act.category), color: AppColors.accent, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(act.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(act.description, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                        const SizedBox(height: 6),
                        Row(children: [
                          _chip2('${act.durationHours}h', Icons.access_time_outlined),
                          const SizedBox(width: 6),
                          _chip2(act.cost == 0 ? 'Free' : '\$${act.cost.toInt()}', Icons.attach_money),
                          const SizedBox(width: 6),
                          _chip2(act.category, Icons.label_outline),
                        ]),
                      ])),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setS(() => act.isAdded = !act.isAdded),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: act.isAdded ? AppColors.teal : AppColors.accentLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(act.isAdded ? Icons.check : Icons.add, color: Colors.white, size: 18),
                        ),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Sightseeing': return Icons.photo_camera;
      case 'Culture': return Icons.museum;
      case 'Adventure': return Icons.hiking;
      case 'Food': return Icons.restaurant;
      case 'Nature': return Icons.park;
      default: return Icons.star;
    }
  }

  Widget _chip2(String text, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(6)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 10, color: AppColors.textLight),
      const SizedBox(width: 3),
      Text(text, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
    ]),
  );
}

