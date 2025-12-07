import 'package:daepiro/presentation/network_no_connect/shelters/dummy_shelter_gwangjin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'mbtiles_provider.dart';
import 'copy_mbtiles.dart';
import 'mbtiles_tileprovider.dart';

class OfflineMapPage extends StatefulWidget {
  const OfflineMapPage({super.key});

  @override
  State<OfflineMapPage> createState() => _OfflineMapPageState();
}

class _OfflineMapPageState extends State<OfflineMapPage> {
  final MBTilesProvider _provider = MBTilesProvider();
  bool _ready = false;
  late final latitude;
  late final longitude;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final path = await copyMbtiles();
    await _provider.open(path);
    final location = await Geolocator.getLastKnownPosition();
    latitude = location?.latitude;
    longitude = location?.longitude;
    setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('서울 대피소 오프라인 지도')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(latitude, longitude),
          //initialCenter: LatLng(37.498095, 127.027610),
          initialZoom: 15,
          minZoom: 10,
          maxZoom: 16,
          //광진구 최대 위치로 설정
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
              const LatLng(37.520, 127.06), // SW
              const LatLng(37.580, 127.12), // NE
            ),
          // ),
          // cameraConstraint: CameraConstraint.contain(
          //   bounds: LatLngBounds(
          //     const LatLng(37.4650, 127.0200), // SW
          //     const LatLng(37.5510, 127.1530), // NE
          //   ),
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: '',
            tileProvider: MBTilesTileProvider(
              getTile: (z, x, y) => _provider.getTile(z, x, y),
            ),
            tileDisplay: const TileDisplay.fadeIn(),
            fallbackUrl: null,
          ),

          MarkerLayer(
            markers:
                shelters.map((s) {
                  return Marker(
                    width: 40,
                    height: 40,
                    point: LatLng(s.lat, s.lng),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 32,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
