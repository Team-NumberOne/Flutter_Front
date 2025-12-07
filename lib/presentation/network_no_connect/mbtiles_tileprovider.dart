import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';

class MBTilesTileProvider extends TileProvider {
  final Future<Uint8List?> Function(int z, int x, int y) getTile;

  MBTilesTileProvider({required this.getTile});

  @override
  ImageProvider<Object> getImage(
      TileCoordinates coords,
      TileLayer options,
      ) {
    return _MBTileImageProvider(
      z: coords.z,
      x: coords.x,
      y: coords.y,
      fetcher: getTile,
    );
  }
}

class _MBTileImageProvider
    extends ImageProvider<_MBTileImageProvider> {
  final int z;
  final int x;
  final int y;
  final Future<Uint8List?> Function(int z, int x, int y) fetcher;

  const _MBTileImageProvider({
    required this.z,
    required this.x,
    required this.y,
    required this.fetcher,
  });

  @override
  Future<_MBTileImageProvider> obtainKey(
      ImageConfiguration configuration) {
    return SynchronousFuture<_MBTileImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
      _MBTileImageProvider key,
      ImageDecoderCallback decode, // Flutter 3.16+ API
      ) {
    return OneFrameImageStreamCompleter(_loadAsync(decode));
  }

  Future<ImageInfo> _loadAsync(ImageDecoderCallback decode) async {
    final bytes = await fetcher(z, x, y);

    final data = (bytes != null && bytes.isNotEmpty)
        ? bytes
        : TileProvider.transparentImage;

    final buffer = await ImmutableBuffer.fromUint8List(data);
    final descriptor = await ImageDescriptor.encoded(buffer);
    final codec = await descriptor.instantiateCodec();

    final frame = await codec.getNextFrame();
    return ImageInfo(image: frame.image);
  }
}