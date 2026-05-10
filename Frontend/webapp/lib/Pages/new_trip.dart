import 'package:flutter/material.dart';
import 'package:webapp/Pages/root.dart';
import '../main.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});
  @override State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  DateTime startDate = DateTime.now().add(const Duration(days: 7));
  DateTime endDate = DateTime.now().add(const Duration(days: 14));
  String selectedEmoji = '✈️';
  final emojis = ['✈️','🗼','🏯','🌴','🏖️','🗽','⛩️','🏔️','🌍','🚢','🎡','🏛️'];
  double budget = 2000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Trip'), leading: const BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover emoji picker
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: AppColors.accentLight, borderRadius: BorderRadius.circular(24)),
                    alignment: Alignment.center,
                    child: Text(selectedEmoji, style: const TextStyle(fontSize: 40)),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: emojis.map((e) => GestureDetector(
                      onTap: () => setState(() => selectedEmoji = e),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: selectedEmoji == e ? AppColors.accent : AppColors.bg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(e, style: const TextStyle(fontSize: 20)),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TLTextField(hint: 'e.g. Europe Dream Tour', label: 'Trip Name', controller: nameCtrl, icon: Icons.title),
            const SizedBox(height: 16),
            TLTextField(hint: 'Describe your adventure...', label: 'Description', controller: descCtrl, icon: Icons.notes),
            const SizedBox(height: 16),
            // Date pickers
            Row(children: [
              Expanded(child: _datePicker('Start Date', startDate, (d) => setState(() => startDate = d))),
              const SizedBox(width: 12),
              Expanded(child: _datePicker('End Date', endDate, (d) => setState(() => endDate = d))),
            ]),
            const SizedBox(height: 20),
            // Budget slider
            Row(children: [
              const Text('Budget', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textLight)),
              const Spacer(),
              Text('\$${budget.toInt()}', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.accent, fontSize: 16)),
            ]),
            Slider(
              value: budget,
              min: 500,
              max: 10000,
              divisions: 19,
              activeColor: AppColors.accent,
              onChanged: (v) => setState(() => budget = v),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TLButton(
                label: 'Create Trip',
                onTap: () {
                  if (nameCtrl.text.isEmpty) return;
                  appState.addTrip(Trip(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameCtrl.text,
                    description: descCtrl.text,
                    coverEmoji: selectedEmoji,
                    startDate: startDate,
                    endDate: endDate,
                    stops: [],
                    budget: budget,
                  ));
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datePicker(String label, DateTime date, Function(DateTime) onChanged) {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime.now(), lastDate: DateTime(2030));
        if (d != null) onChanged(d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('${date.day}/${date.month}/${date.year}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        ]),
      ),
    );
  }
}
