import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/exceptions.dart';
import 'package:meteo_uyari/classes/helpers.dart';
import 'package:meteo_uyari/models/city.dart';
import '../classes/supabase.dart' as supabase;
import '../models/town.dart';

class AddTownPage extends StatelessWidget {
  ///Pass it for preventing user to select same [Town]'s
  final List<Town>? existingTowns;

  ///Page for letting user adding another cities.
  ///
  ///If user adds city, it will setup notifications itself.
  const AddTownPage({super.key, this.existingTowns});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: FutureBuilder(
                future: supabase.getCitiesRpc(),
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
                    return _AddCityLoaded(
                      cities: cities,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ),
        ));
  }
}

class _AddCityLoaded extends StatefulWidget {
  final List<City> cities;
  const _AddCityLoaded({required this.cities});

  @override
  State<_AddCityLoaded> createState() => _AddCityLoadedState();
}

class _AddCityLoadedState extends State<_AddCityLoaded> {
  late final allCities = widget.cities;
  Town? selectedTown;
  City? selectedCity;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("Yer seçin"),
        //City selector
        DropdownMenu(
          dropdownMenuEntries: [
            for (final city in allCities)
              DropdownMenuEntry(value: city, label: city.name)
          ],
          onSelected: (value) {
            if (value != null) {
              setState(() {
                selectedCity = value;
              });
            }
          },
        ),
        //Town selector
        DropdownMenu(
          enabled: selectedCity != null,
          dropdownMenuEntries: [
            for (final town in selectedCity?.towns ?? <Town>[])
              DropdownMenuEntry(value: town, label: town.name)
          ],
          onSelected: (value) {
            if (value != null) {
              setState(() {
                selectedTown = value;
              });
            }
          },
        ),
        ElevatedButton(
            onPressed: selectedTown == null
                ? null
                : () async {
                    final result =
                        await setNotificationForNewTown(selectedTown!);
                    if (result && mounted) {
                      Navigator.pop(context, selectedTown);
                    }
                  },
            child: const Text("Tamam"))
      ],
    );
  }
}
