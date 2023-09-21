import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/helpers.dart' as helpers;

import '../../models/city.dart';

class SelectLocation extends StatelessWidget {
  final void Function(City city) onLocationSet;

  const SelectLocation({super.key, required this.onLocationSet});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: helpers.getCities(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SelectLocationLoaded(
              cities: snapshot.data!,
              onLocationSet: onLocationSet,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }));
  }
}

class SelectLocationLoaded extends StatefulWidget {
  final void Function(City city) onLocationSet;
  final List<City> cities;
  const SelectLocationLoaded(
      {super.key, required this.cities, required this.onLocationSet});

  @override
  State<SelectLocationLoaded> createState() => _SelectLocationLoadedState();
}

class _SelectLocationLoadedState extends State<SelectLocationLoaded> {
  City? selectedCity;
  bool buttonAvailable = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Hava uyarılarını almak için bulunduğunuz yeri seçin"),
        DropdownMenu(
          dropdownMenuEntries: widget.cities
              .map((e) => DropdownMenuEntry(value: e.centerId, label: e.name))
              .toList(),
          onSelected: (index) {
            if (index != null) {
              selectedCity =
                  widget.cities.singleWhere((city) => city.centerId == index);
              setState(() {
                buttonAvailable = true;
              });
            } else {
              selectedCity == null;
              setState(() {
                buttonAvailable = false;
              });
            }
          },
        ),
        ElevatedButton(
            onPressed: buttonAvailable
                ? () => widget.onLocationSet(selectedCity!)
                : null,
            child: const Text("Devam")),
      ],
    );
  }
}
