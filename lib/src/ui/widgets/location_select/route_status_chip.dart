part of 'route_card.dart';


// ─────────────────────────────────────────────────────────────────
// Route status chip (shown while building / if OSRM failed)
// ─────────────────────────────────────────────────────────────────

class _RouteStatusChip extends StatelessWidget {
  final bool isLoading;
  const _RouteStatusChip({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 14, height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 1.8,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Building route…',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 12, fontWeight: FontWeight.w600,
                ),
              ),
            ] else ...[
              Icon(Icons.route_rounded, color: Colors.white.withOpacity(0.25), size: 15),
              const SizedBox(width: 8),
              Text(
                'Waiting for road route…',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 12, fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

