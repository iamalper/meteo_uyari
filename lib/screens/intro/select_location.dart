import 'package:flutter/material.dart';
import 'package:meteo_uyari/themes.dart';
import '../../classes/get_cities.dart';
import '../../models/city.dart';

class SelectLocation extends StatelessWidget {
  final void Function(City city) onLocationSet;

  const SelectLocation({super.key, required this.onLocationSet});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCities(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final error = snapshot.error;
            if (error != null) {
              throw error;
            }
            return _SelectLocationLoaded(
              cities: snapshot.data!,
              onLocationSet: onLocationSet,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }));
  }
}

class _SelectLocationLoaded extends StatefulWidget {
  final void Function(City city) onLocationSet;
  final List<City> cities;
  const _SelectLocationLoaded(
      {required this.cities, required this.onLocationSet});

  @override
  State<_SelectLocationLoaded> createState() => _SelectLocationLoadedState();
}

class _SelectLocationLoadedState extends State<_SelectLocationLoaded> {
  City? _selectedCity;
  late final _onLocationSet = widget.onLocationSet;
  late final _cities = widget.cities;
  var _buttonAvailable = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          "Hava uyarılarını almak için bulunduğunuz yeri seçin",
          style: MyTextStyles.medium(),
        ),
        DropdownMenu(
          dropdownMenuEntries: _cities
              .map((e) => DropdownMenuEntry(value: e.centerId, label: e.name))
              .toList(),
          onSelected: (index) {
            if (index != null) {
              _selectedCity =
                  _cities.singleWhere((city) => city.centerId == index);
              setState(() {
                _buttonAvailable = true;
              });
            } else {
              _selectedCity == null;
              setState(() {
                _buttonAvailable = false;
              });
            }
          },
        ),
        ElevatedButton(
            onPressed:
                _buttonAvailable ? () => _onLocationSet(_selectedCity!) : null,
            child: const Text("Devam")),
      ],
    );
  }
}
