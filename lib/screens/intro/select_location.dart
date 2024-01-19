import 'package:flutter/material.dart';
import 'package:meteo_uyari/themes.dart';
import '../../classes/supabase.dart' as supabase;
import '../../models/city.dart';
import '../../models/town.dart';

class SelectLocation extends StatelessWidget {
  final void Function(City city) onLocationSet;

  const SelectLocation({super.key, required this.onLocationSet});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: supabase.getCities(),
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
  Town? _selectedTown;
  late final _onLocationSet = widget.onLocationSet;
  late final _cities = widget.cities;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          "Hava uyarılarını almak için bulunduğunuz yeri seçin",
          style: MyTextStyles.medium(),
        ),
        //City Select
        DropdownMenu(
          dropdownMenuEntries: [
            for (final city in _cities)
              DropdownMenuEntry(value: city, label: city.name)
          ],
          onSelected: (city) {
            setState(() {
              _selectedCity = city;
            });
          },
        ),
        //Town select
        DropdownMenu(
          dropdownMenuEntries: [
            for (final town in _selectedCity?.towns ?? <Town>{})
              DropdownMenuEntry(value: town, label: town.name!)
          ],
          enabled: _selectedCity != null,
          onSelected: (value) {
            _selectedTown = value;
          },
        ),
        ElevatedButton(
            onPressed: _selectedTown != null && _selectedCity != null
                ? () => _onLocationSet(_selectedCity!)
                : null,
            child: const Text("Devam")),
      ],
    );
  }
}
