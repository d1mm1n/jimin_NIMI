import 'package:flutter/material.dart';

class TestView extends StatefulWidget {
  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(
        () => setState(() => _selectedIndex = _tabController.index));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 80,
        child: TabBar(
          indicatorColor: Colors.transparent,
          labelColor: Colors.black,
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                _selectedIndex == 0 ? Icons.person : Icons.person_2_outlined,
              ),
              text: "내 정보",
            ),
            Tab(
              icon: Icon(
                _selectedIndex == 1 ? Icons.chat : Icons.chat_outlined,
              ),
              text: "아이콘은",
            ),
            Tab(
              icon: Icon(
                _selectedIndex == 2 ? Icons.settings : Icons.settings_outlined,
              ),
              text: "나중에 바꿀꺼",
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0
          ? tabContainer(context, Colors.transparent, "페이지 1")
          : _selectedIndex == 1
              ? tabContainer(context, Colors.transparent, "페이지 2")
              : tabContainer(context, Colors.transparent, "페이지 3"),
    );
  }

  Container tabContainer(BuildContext context, Color tabColor, String tabText) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: tabColor,
      child: Center(
        child: Text(
          tabText,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
