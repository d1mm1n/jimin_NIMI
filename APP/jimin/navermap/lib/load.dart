import 'dart:async';
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'button.dart';
import 'dart:convert';
import 'dart:io';

void main() async {
  await _initialize();
  runApp(const NaverMapApp());
}

List<NLatLng> jsonmarker = []; //서버에서 받아온 위도 경도를 저장할 리스트

// 네이버 인증 부분
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NaverMapSdk.instance.initialize(
      clientId: 's5bm2ba7yr',
      onAuthFailed: (ex) => log("********* 네이버맵 인증오류 : $ex *********"));
}

//json에서 위도 경도 데이터 받아오기
Future<void> loadJsonData() async {
  final jsonString = await rootBundle.loadString('assets/data.json');
  final data = json.decode(jsonString);
// 'LatLng' 키의 값을 가져옴
  final List<dynamic> latLngList = data['LatLng'];
  //List<NLatLng> jsonmarker = []; //서버에서 받아온 위도 경도를 저장할 리스트
  // 이제 'data' 변수에 JSON 파일의 리스트 데이터가 들어있습니다.

  // latLngList를 순회하면서 각 항목에 접근
  for (final latLng in latLngList) {
    final latitude = latLng[0];
    final longitude = latLng[1];
    final nLatLng = NLatLng(latitude, longitude);
    jsonmarker.add(nLatLng);

    //print('Latitude: $latitude, Longitude: $longitude');
  }
  print(jsonmarker);
}

//사용자의 출발지 도착지를 json파일로 보내 저장하기
Future<void> sendJsonData() async {}

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
  final List<NLatLng> _markersposition = []; // 출발지, 도착지 위도 경도 리스트
  final List<NMarker> _markers = []; // 저장된 마커 리스트

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

          ElevatedButton(
            child: const Text('길찾기'),
            onPressed: () async {
              print("길찾기 버튼 클릭");
              //json에서 데이터 전송 하고 받기
              //json데이터 전송하기
              List<Map<dynamic, double>> markerMaps = _markersposition
                  .map((marker) => {
                        'latitude': marker.latitude,
                        'longitude': marker.longitude,
                      })
                  .toList();
              print(markerMaps);
              //final StartEnd_data = json.encode(markerMaps);
              //File file = File('assets/SendData.json'); // 파일 경로

              //file.writeAsStringSync(StartEnd_data); // Json 데이터를 파일에 씁니다.
              //print("파일 쓰기 완료");

              //json에서 위도 경도 데이터 받아오기
              await loadJsonData();

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
    if (_markersposition.isEmpty) return;

    final sMarker = NMarker(id: 'test', position: _markersposition[0]);
    final showSmarker = NInfoWindow.onMarker(id: sMarker.info.id, text: "출발지");

    if (_markersposition.length >= 2) {
      final eMarker = NMarker(id: 'test1', position: _markersposition[1]);
      final showEmarker =
          NInfoWindow.onMarker(id: eMarker.info.id, text: "도착지");

      _mapController.addOverlay(eMarker);
      //addOverlay 하고 openInfoWindow 해야 출발 도착 글씨가 보임 이거때매 ㅅㅂ
      //한시간 개 지랄함
      eMarker.openInfoWindow(showEmarker);
    } else {
      _mapController.clearOverlays();
      _mapController.addOverlay(sMarker);
      sMarker.openInfoWindow(showSmarker);
    }
  }

  void drawPath(NaverMapController Controller) {
    if (jsonmarker.length >= 2) {
      final pathOverlay = NPathOverlay(
        //길 위도 경도를 순서대로 넣어야함!
        //그래야 순서대로 길이 이어짐

        coords: jsonmarker,
        color: Colors.red,
        width: 7.0,
        id: 'walkPath',
      );

      Controller.addOverlay(pathOverlay);
    }
    //중복 선이 그려지지 않도록 길 경로 위도 경도 리스트 비워주기
    jsonmarker.clear();
  }
}
