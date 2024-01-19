import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/exceptions.dart';
import 'package:meteo_uyari/classes/helpers.dart';
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
                future: supabase.getTowns(),
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
                    final towns = snapshot.data!;
                    if (existingTowns != null) {
                      for (final savedCity in existingTowns!) {
                        towns.remove(savedCity);
                      }
                    }
                    return _AddTownLoaded(
                      towns: towns,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ),
        ));
  }
}

class _AddTownLoaded extends StatefulWidget {
  final List<Town> towns;
  const _AddTownLoaded({required this.towns});

  @override
  State<_AddTownLoaded> createState() => _AddTownLoadedState();
}

class _AddTownLoadedState extends State<_AddTownLoaded> {
  Town? selectedTown;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("Yer seçin"),
        DropdownMenu(
          dropdownMenuEntries: [
            for (final town in widget.towns)
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
