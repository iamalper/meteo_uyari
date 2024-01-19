import 'package:flutter/material.dart';
import 'package:meteo_uyari/models/alert.dart';
import 'package:meteo_uyari/screens/alerts_page.dart';

import '../models/town.dart';

class AlertsPageView extends StatefulWidget {
  ///[PageView] for listing [AlertsPage] pages
  ///and managing slide effects.
  const AlertsPageView(
      {super.key,
      required this.pageController,
      required this.towns,
      required this.data,
      required this.tabController});

  final PageController pageController;
  final Set<Town> towns;
  final List<Alert> data;
  final TabController tabController;

  @override
  State<AlertsPageView> createState() => _AlertsPageViewState();
}

class _AlertsPageViewState extends State<AlertsPageView> {
  late final _pageController = widget.pageController;
  late final _towns = widget.towns;
  late final _allAlerts = widget.data;
  late final _tabController = widget.tabController;
  late var _pagePosition = _pageController.initialPage.toDouble();
  double get _screenSizeY => MediaQuery.sizeOf(context).height;
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
      itemCount: _towns.length,
      //findChildIndexCallback: (key) => (key as ValueKey<int>).value,
      itemBuilder: (context, index) => Transform.translate(
        offset: Offset(0, (_pagePosition - index).abs() * _screenSizeY),
        child: Opacity(
          opacity: 1 -
              (_pagePosition - index).abs(), //FIXME: Opaque may out of range
          child: AlertsPage(
            alerts: [
              for (final alert in _allAlerts)
                if (alert.towns.contains(_towns.elementAt(index))) alert
            ],
            cityName: _towns.elementAt(index).name,
            //key: ValueKey(index),
          ),
        ),
      ),
      onPageChanged: (value) => _tabController.animateTo(value),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
