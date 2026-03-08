import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapFunctions {
  final MapController controller;
  final TickerProvider vsync; // 👈 receive it, don't mix it in

  MapFunctions({required this.controller, required this.vsync});

  void animatedMove(LatLng destination, double zoom) {
    final latTween = Tween<double>(
      begin: controller.camera.center.latitude,
      end: destination.latitude,
    );
    final lngTween = Tween<double>(
      begin: controller.camera.center.longitude,
      end: destination.longitude,
    );
    final zoomTween = Tween<double>(
      begin: controller.camera.zoom,
      end: zoom,
    );

    final animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync, // 👈 use the passed-in vsync
    );

    final animation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeInOut,
    );

    animController.addListener(() {
      controller.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        animController.dispose();
      }
    });

    animController.forward();
  }
}