part of 'route_card.dart';


// ─────────────────────────────────────────────────────────────────
// Confirm Route button
// ─────────────────────────────────────────────────────────────────

class _ConfirmRouteButton extends StatefulWidget {
  const _ConfirmRouteButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_ConfirmRouteButton> createState() => _ConfirmRouteButtonState();
}

class _ConfirmRouteButtonState extends State<_ConfirmRouteButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF06D6A0);
    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: ()  => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: _pressed
                  ? [green.withOpacity(0.7), const Color(0xFF4CC9F0).withOpacity(0.7)]
                  : [green, const Color(0xFF4CC9F0)],
            ),
            boxShadow: [
              BoxShadow(
                color: green.withOpacity(_pressed ? 0.2 : 0.4),
                blurRadius: 20, offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Symbols.check_circle, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Confirm Route',
                style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700,
                  fontSize: 14, letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}