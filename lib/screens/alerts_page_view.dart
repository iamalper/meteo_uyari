import 'package:flutter/material.dart';
import 'package:meteo_uyari/models/alert.dart';
import 'package:meteo_uyari/models/city.dart';
import 'package:meteo_uyari/screens/alerts_page.dart';

class AlertsPageView extends StatefulWidget {
  const AlertsPageView({
    super.key,
    required this.pageController,
    required this.cities,
    required this.data,
    required this.tabController,
  });

  final PageController pageController;
  final List<City> cities;
  final List<Alert> data;
  final TabController tabController;

  @override
  State<AlertsPageView> createState() => _AlertsPageViewState();
}

class _AlertsPageViewState extends State<AlertsPageView> {
  late final _pageController = widget.pageController;
  late final _cities = widget.cities;
  late final _data = widget.data;
  late final _tabController = widget.tabController;
  late var _pagePosition = _pageController.initialPage.toDouble();
  late final _screenSizeY = MediaQuery.of(context).size.height;
  @override
  void initState() {
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _pagePosition = _pageController.page!;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      physics: const BouncingScrollPhysics(),
      itemCount: _cities.length,
      findChildIndexCallback: (key) => (key as ValueKey<int>).value,
      itemBuilder: (context, index) => Transform.translate(
        offset: Offset(0, (_pagePosition - index).abs() * _screenSizeY),
        child: Opacity(
          opacity: 1 - (_pagePosition - index).abs(),
          child: AlertsPage(
            alerts: _data
                .where((element) =>
                    element.towns.contains(_cities[index].centerIdInt))
                .toList(),
            cityName: _cities[index].name,
            key: ValueKey(index),
          ),
        ),
      ),
      onPageChanged: (value) => _tabController.animateTo(value),
    );
  }
}
