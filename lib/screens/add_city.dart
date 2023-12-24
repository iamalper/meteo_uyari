import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/exceptions.dart';
import 'package:meteo_uyari/classes/helpers.dart';
import '../classes/get_cities.dart';
import '../models/city.dart';

class AddCityPage extends StatelessWidget {
  ///Pass it for preventing user to select same cities
  final List<City>? savedCities;

  ///Page for letting user adding another cities.
  ///
  ///If user adds city, it will setup notifications itself.
  const AddCityPage({super.key, this.savedCities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: FutureBuilder(
              future: getCities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final error = snapshot.error;
                  if (error != null) {
                    if (error is MeteoUyariException) {
                      return Text(error.message);
                    } else {
                      throw error;
                    }
                  }
                  final cities = snapshot.data!;
                  if (savedCities != null) {
                    for (final savedCity in savedCities!) {
                      cities.remove(savedCity);
                    }
                  }
                  return _AddCityPageLoaded(
                    cities: cities,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}

class _AddCityPageLoaded extends StatefulWidget {
  final List<City> cities;
  const _AddCityPageLoaded({required this.cities});

  @override
  State<_AddCityPageLoaded> createState() => _AddCityPageLoadedState();
}

class _AddCityPageLoadedState extends State<_AddCityPageLoaded> {
  City? selectedCity;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("Şehir seçin"),
        DropdownMenu(
          dropdownMenuEntries: widget.cities
              .map((e) => DropdownMenuEntry(value: e, label: e.name))
              .toList(),
          onSelected: (value) {
            if (value != null) {
              setState(() {
                selectedCity = value;
              });
            }
          },
        ),
        ElevatedButton(
            onPressed: selectedCity == null
                ? null
                : () async {
                    final result =
                        await setNotificationForNewCity(selectedCity!);
                    if (result && mounted) {
                      Navigator.pop(context, selectedCity);
                    }
                  },
            child: const Text("Tamam"))
      ],
    );
  }
}
