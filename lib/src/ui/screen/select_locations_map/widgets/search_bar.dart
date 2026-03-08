part of '../select_locations_map.dart';


class _SearchBar extends StatelessWidget {
  final VoidCallback onTap;
  const _SearchBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.black54,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
        leading: const Icon(Icons.search_rounded, color: Color(0xFFFF6B35), size: 18),
        title: Text('Search location…',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 13,
            )),
      ),
    );
  }
}