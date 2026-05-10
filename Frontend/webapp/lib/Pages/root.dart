import 'package:flutter/material.dart';
import '../main.dart';


class TLButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;
  final Color? color;
  final IconData? icon;

  const TLButton({super.key, required this.label, required this.onTap, this.filled = true, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.accent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: filled ? bg : Colors.transparent,
          border: Border.all(color: bg, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 18, color: filled ? Colors.white : bg), const SizedBox(width: 8)],
            Text(label, style: TextStyle(color: filled ? Colors.white : bg, fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class TLTextField extends StatelessWidget {
  final String hint, label;
  final bool obscure;
  final TextEditingController? controller;
  final IconData? icon;
  final TextInputType? keyboardType;

  const TLTextField({super.key, required this.hint, required this.label, this.obscure = false, this.controller, this.icon, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textLight)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.text, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textLight),
            prefixIcon: icon != null ? Icon(icon, color: AppColors.textLight, size: 20) : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accent, width: 2)),
          ),
        ),
      ],
    );
  }
}

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const TripCard({super.key, required this.trip, required this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isPast = trip.endDate.isBefore(DateTime.now());
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: isPast ? AppColors.primary : AppColors.accent,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  Positioned(right: -20, top: -20, child: Text(trip.coverEmoji, style: const TextStyle(fontSize: 80))),
                  Positioned(left: 16, bottom: 12, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.name, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                      Row(children: [
                        if (trip.isPublic) Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                          child: const Text('Public', style: TextStyle(color: Colors.white, fontSize: 11)),
                        ),
                      ]),
                    ],
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  _chip(Icons.location_on_outlined, '${trip.stops.length} cities'),
                  const SizedBox(width: 8),
                  _chip(Icons.calendar_today_outlined, '${trip.durationDays}d'),
                  const SizedBox(width: 8),
                  _chip(Icons.attach_money, '\$${trip.budget.toInt()}'),
                  const Spacer(),
                  if (onDelete != null) GestureDetector(
                    onTap: onDelete,
                    child: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(8)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: AppColors.textLight),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.w500)),
    ]),
  );
}