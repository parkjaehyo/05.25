import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'flask_UmbrellaCount.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<NaverMapController> _mapControllerCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('우산 대여 지도'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: NaverMap(
          options: const NaverMapViewOptions(
            indoorEnable: true,
            locationButtonEnable: false,
            consumeSymbolTapEvents: true,
            initialCameraPosition: NCameraPosition(
              target: NLatLng(37.4535, 129.1633),
              zoom: 15,
            ),
          ),
          onMapReady: (controller) async {
            _mapControllerCompleter.complete(controller);
            final markers = [
              _createMarker(controller, '1', 37.453074, 129.160954, '1공학관'),
              _createMarker(controller, '2', 37.453568, 129.161179, '2공학관'),
              _createMarker(controller, '3', 37.452109, 129.160983, '3공학관'),
              _createMarker(controller, '4', 37.452056, 129.159390, '4공학관'),
            ];
            await Future.wait(markers);
          },
        ),
      ),
    );
  }

  Future<void> _createMarker(
    NaverMapController controller,
    String id,
    double lat,
    double lng,
    String title,
  ) async {
    final marker = NMarker(
      id: id,
      position: NLatLng(lat, lng),
      caption: NOverlayCaption(text: title),
    );

    marker.setOnTapListener((_) {
      _showUmbrellaDialog(title, id);
    });

    await controller.addOverlay(marker);
  }

  void _showUmbrellaDialog(String title, String id) {
    Map<String, dynamic>? umbrellaData;
    bool isLoading = true;
    late void Function(VoidCallback) localSetState;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            localSetState = setState;

            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('강원대학교 삼척캠퍼스'),
                  const SizedBox(height: 10),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (umbrellaData != null)
                    Text(
                      '현재 우산 수량: ${umbrellaData!['count'][0]['current_count']} / ${umbrellaData!['count'][0]['max_count']}',
                    )
                  else
                    const Text('우산 현황을 불러올 수 없습니다.'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('닫기'),
                ),
              ],
            );
          },
        );
      },
    );

    // 다이얼로그가 뜬 이후에 서버 데이터 1회만 불러옴
    Future.microtask(() async {
      try {
        print('❓ 서버 요청 중...');
        final data = await UmbrellaService.fetchUmbrellaStatus(int.parse(id));
        print('✅ 서버 응답: $data');

        if (Navigator.of(context).canPop()) {
          localSetState(() {
            umbrellaData = data;
            isLoading = false;
          });
        }
      } catch (e) {
        print('❌ 데이터 로드 실패: $e');
        if (Navigator.of(context).canPop()) {
          localSetState(() {
            isLoading = false;
            umbrellaData = null;
          });
        }
      }
    });
  }
}
