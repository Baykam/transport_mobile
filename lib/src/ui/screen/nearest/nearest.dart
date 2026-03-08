
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:transport/src/ui/widgets/map/map.dart';


class NearestScreen extends StatelessWidget {
  const NearestScreen({super.key});


  final List<LatLng> markerPoints = const [
    LatLng(41.0082, 28.9784),
    LatLng(39.9334, 32.8597),
    LatLng(38.4192, 27.1287),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapView(
        markers: markerPoints.map((e) => Marker(
            point: e,
            height: 54,
            width: 54,
            child: Column(
              children: [
                Text('Some Data',maxLines: 1,overflow: TextOverflow.ellipsis,),
                Icon(Icons.location_pin),
              ],
            )),
        ).toList(),
      ),
    );
  }
}