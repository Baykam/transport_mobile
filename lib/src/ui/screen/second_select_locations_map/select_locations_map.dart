import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:transport/src/ui/router/path.dart';
import 'package:transport/src/ui/widgets/map/map.dart';

part 'widgets/centre_marker.dart';
part 'widgets/app_bar.dart';
part 'widgets/search_delegate.dart';
part 'widgets/swipe_map_hint.dart';
class SecondSelectLocationsMap extends StatefulWidget {
  const SecondSelectLocationsMap({super.key});

  @override
  State<SecondSelectLocationsMap> createState() => _SecondSelectLocationsMapState();
}

class _SecondSelectLocationsMapState extends State<SecondSelectLocationsMap> {
  bool routeCreatePosition = false;
  final Duration duration = Duration(milliseconds: 320);
  final Duration durationTap = Duration(milliseconds: 100);

  void onChangeRouteCreate() async {
    await Future.delayed(durationTap);
    setState(() => routeCreatePosition = !routeCreatePosition);
  }

  void onSearch() async {
    final result = await showSearch(
      context: context,
      delegate: LocationSearchDelegate(),
    );
   print(result);
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top + 12;

    // ── Shared palette (consistent with AppBarMap2) ──
    const Color accent      = Color(0xFF818CF8); // Soft Indigo
    const Color darkSurface = Color(0xFF1E293B); // Koyu Slate
    const Color cardSurface = Color(0xFF0D1117); // En koyu, bottom panel için

    return Scaffold(
      backgroundColor: cardSurface,
      body: Stack(
        children: [
          // ── Map ──
          Positioned.fill(
            child: MapView(
              needTopGradient: true,
              needButtons: !routeCreatePosition,
            ),
          ),

          // ── App Bar ──
          AppBarMap2(needSearch: routeCreatePosition,onSearch: onSearch,),

          // ── Location Selector Tile ──
          AnimatedPositioned(
            duration: duration,
            curve: routeCreatePosition ? Curves.easeInOut : Curves.easeOutBack,
            top: topPad + (routeCreatePosition ? -400 : 60),
            right: 30,
            left: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                // FIX: Colors.black54 yerine tema ile uyumlu koyu slate
                color: darkSurface,
                child: ExpansionTile(
                  leading: Icon(
                    Symbols.navigation_rounded,
                    // FIX: ikon rengini accent ile belirt
                    color: accent,
                  ),
                  title: Text(
                    'Select Location',
                    // FIX: başlık rengi
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  // FIX: açık/kapalı ok renkleri
                  iconColor: accent,
                  collapsedIconColor: const Color(0xFFCBD5E1),
                  // FIX: tile arkaplanını da uyumlu yap
                  backgroundColor: darkSurface,
                  collapsedBackgroundColor: darkSurface,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: onChangeRouteCreate,
                        leading: const Icon(Symbols.location_on, color: accent, size: 18),
                        title: const Text(
                          'Asgabat saher hakimlik',
                          style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: onChangeRouteCreate,
                        leading: const Icon(Symbols.location_on, color: accent, size: 18),
                        title: const Text(
                          'Asgabat saher parahat 3/1',
                          style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
                        ),
                      ),
                    ),
                    
                    Divider(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: ()=> context.pushNamed(AppPath.createData.path),
                        child: Text('Confirm Route'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // ── Center Pin ──
          if (routeCreatePosition)
            _MapCenterPin(
              isDropping: true,
              isFloating: false,
              // FIX: pin rengi accent ile değiştirildi (siyah yarı saydam yerine)
              color: accent,
            ),

          // ── "Please select location" Hint ──
          Positioned(
            top: topPad + 60,
            right: 70,
            left: 70,
            child: MapHint(needHint: routeCreatePosition),
          ),

          // ── Bottom Confirm Panel ──
          AnimatedPositioned(
            curve: Curves.easeOutCubic,
            bottom: routeCreatePosition ? 0 : -220,
            right: 0,
            left: 0,
            duration: duration,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
              decoration: BoxDecoration(
                color: cardSurface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(color: Colors.white.withOpacity(0.09)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.55),
                    blurRadius: 32,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Address Row ──
                  Row(
                    children: [
                      const Icon(Symbols.location_on, color: accent, size: 20),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Aşgabat, Parahat 3/1, Binalar toplumy...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Confirm Button ──
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: onChangeRouteCreate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const Text(
                        'Confirm Location',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}