import 'package:flutter/material.dart';
import 'package:webapp/Pages/root.dart';
import '../main.dart';

class PackingChecklistScreen extends StatelessWidget {
  const PackingChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final cats = <String, List<ChecklistItem>>{};
        for (final item in appState.checklistItems) {
          cats.putIfAbsent(item.category, () => []).add(item);
        }
        final packed = appState.checklistItems.where((i) => i.isPacked).length;
        final total = appState.checklistItems.length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Packing List'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.accent),
                onPressed: () => _showAdd(context),
              ),
            ],
          ),
          body: Column(
            children: [
              // Progress
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('$packed / $total packed', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                    Text('${total > 0 ? ((packed / total) * 100).toInt() : 0}%', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w800, fontSize: 20)),
                  ]),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: total > 0 ? packed / total : 0,
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: cats.entries.map((e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(children: [
                          Container(width: 4, height: 16, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 8),
                          Text(e.key, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.text)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.accentLight, borderRadius: BorderRadius.circular(10)),
                            child: Text('${e.value.where((i) => i.isPacked).length}/${e.value.length}',
                              style: const TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w600)),
                          ),
                        ]),
                      ),
                      ...e.value.map((item) => GestureDetector(
                        onTap: () => appState.togglePackedItem(item.id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: item.isPacked ? AppColors.tealLight : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: item.isPacked ? AppColors.teal : AppColors.border),
                          ),
                          child: Row(children: [
                            Container(
                              width: 22, height: 22,
                              decoration: BoxDecoration(
                                color: item.isPacked ? AppColors.teal : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(color: item.isPacked ? AppColors.teal : AppColors.textLight, width: 1.5),
                              ),
                              child: item.isPacked ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                            ),
                            const SizedBox(width: 12),
                            Text(item.name, style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: item.isPacked ? AppColors.teal : AppColors.text,
                              decoration: item.isPacked ? TextDecoration.lineThrough : null,
                            )),
                          ]),
                        ),
                      )),
                      const SizedBox(height: 4),
                    ],
                  )).toList(),
                ),
              ),
            ],
            
          ),
        );
      },
    );
  }

  void _showAdd(BuildContext context) {
    final nameCtrl = TextEditingController();
    String selectedCat = 'Clothing';
    final cats = ['Clothing', 'Documents', 'Electronics', 'Toiletries', 'Other'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('Add Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            TLTextField(hint: 'Item name...', label: 'Item', controller: nameCtrl),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: cats.map((c) => GestureDetector(
                onTap: () => setS(() => selectedCat = c),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selectedCat == c ? AppColors.accent : AppColors.bg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(c, style: TextStyle(color: selectedCat == c ? Colors.white : AppColors.text, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),
            TLButton(label: 'Add Item', onTap: () {
              if (nameCtrl.text.isNotEmpty) {
                appState.addChecklistItem(nameCtrl.text, selectedCat);
                Navigator.pop(ctx);
              }
            }),
          ]),
        ),
      ),
      
    );
    
  }
}