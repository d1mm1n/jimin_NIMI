import 'dart:async';
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'button.dart';
import 'package:provider/provider.dart';

void main() async {
  await _initialize();
  runApp(const NaverMapApp());
}

// 네이버 인증 부분
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: 's5bm2ba7yr',
      onAuthFailed: (ex) => log("********* 네이버맵 인증오류 : $ex *********"));
}

class NaverMapApp extends StatelessWidget {
  final int? testId;
  const NaverMapApp({super.key, this.testId});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: testId == null
            ? const TestPage()
            : TestPage(key: Key("testPage_$testId")),
      );
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  late NaverMapController _mapController;
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  List<NLatLng> _markersposition = []; // 마커 위도 경도 리스트
  List<NMarker> _markers = []; // 저장된 마커 리스트

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final pixelRatio = mediaQuery.devicePixelRatio;
    final mapSize =
        Size(mediaQuery.size.width - 5, mediaQuery.size.height - 130);
    final physicalSize =
        Size(mapSize.width * pixelRatio, mapSize.height * pixelRatio);

    print("physicalSize: $physicalSize");

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Container(
            // 맵을 위쪽 정렬
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: mapSize.width,
              height: mapSize.height,
              child: _naverMapSection(),
            ),
          ),
          SizedBox(height: 20), // 버튼과 지도 사이에 간격 조정
          // button.dart에 만들어 놓은 길찾기 버튼 (내가 만든 외부 클래스임)
          ElevatedButton(
            child: const Text('길찾기'),
            onPressed: () {
              print("길찾기 버튼 클릭");
              drawPath(_mapController);
            },
          ),
        ],
      ),
    );
  }

  // 지도 위젯을 생성하는 부분
  Widget _naverMapSection() => NaverMap(
        options: const NaverMapViewOptions(
          // 초기 카메라 위치 설정: 순천향 대학교로 설정
          initialCameraPosition: NCameraPosition(
            target: NLatLng(36.770769, 126.9316), // 위도 경도
            zoom: 16, // 확대 축소 레벨
            bearing: 0,
            tilt: 0,
          ),
          indoorEnable: true, // 지도 내의 실내 맵을 표시할 수 있는 기능
          locationButtonEnable: false, // 현재 위치를 표시하는 버튼의 활성화 여부
          consumeSymbolTapEvents: false,
        ),
        onMapReady: (controller) async {
          _mapController = controller;

          mapControllerCompleter.complete(controller);
          log("onMapReady", name: "onMapReady");
        },
        // 지도를 클릭했을 때의 콜백 함수
        onMapTapped: (point, coord) {
          if (_markersposition.length >= 2) {
            // 이미 2개 이상의 요소가 저장되어 있다면 모든 요소 초기화
            _markersposition.clear();
            // 지도 위에 기존 마커 제거
            _mapController.clearOverlays();
          }
          // 클릭한 위치의 경도, 위도 정보를 가져옴
          double latitude = coord.latitude;
          double longitude = coord.longitude;

          // 클릭한 위치의 위도 경도를 리스트에 저장
          _markersposition.add(NLatLng(latitude, longitude));
          print(_markersposition);

          addMarker();
        },
      );

  // 마커 추가 함수
  void addMarker() {
    print(_markersposition);
    if (_markersposition.isNotEmpty) {
      final s_marker = NMarker(id: 'test', position: _markersposition[0]);

      final show_smarker =
          NInfoWindow.onMarker(id: s_marker.info.id, text: "출발");
      s_marker.openInfoWindow(show_smarker);

      if (_markersposition.length >= 2) {
        final e_marker = NMarker(id: 'test1', position: _markersposition[1]);
        final show_emarker =
            NInfoWindow.onMarker(id: e_marker.info.id, text: "도착");
        e_marker.openInfoWindow(show_emarker);

        _mapController.clearOverlays();
        _mapController.addOverlayAll({s_marker, e_marker});
        // 길찾기 버튼을 눌렀을 때만 경로 그리기 함수 실행
      } else {
        _mapController.clearOverlays();
        _mapController.addOverlay(s_marker);
      }
    } else {
      return;
    }
  }

  void drawPath(NaverMapController Controller) {
    if (_markersposition.length >= 2) {
      final pathOverlay = NPathOverlay(
        coords: _markersposition
        //NLatLng(37.506932467450326, 127.05578661133796), // 출발지 좌표
        //NLatLng(37.606932467450326, 127.05578661133796), // 도착지 좌표
        ,
        color: Colors.red,
        width: 8.0,
        id: 'walkPath',
      );

      Controller.addOverlay(pathOverlay);
    }
  }
}
