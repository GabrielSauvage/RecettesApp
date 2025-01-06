import 'package:flutter/material.dart';
import '../../models/country.dart';

class CountryCard extends StatelessWidget {
  final Country country;

  const CountryCard({required this.country});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (country.strArea != 'Unknown')
            Expanded(
              child: Image.network(
                getFlagUrl(country.strArea),
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              country.strArea,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String getFlagUrl(String country) {
    final countryCodes = {
      'American': 'us',
      'British': 'gb',
      'Canadian': 'ca',
      'Chinese': 'cn',
      'Croatian': 'hr',
      'Dutch': 'nl',
      'Egyptian': 'eg',
      'Filipino': 'ph',
      'French': 'fr',
      'Greek': 'gr',
      'Indian': 'in',
      'Irish': 'ie',
      'Italian': 'it',
      'Jamaican': 'jm',
      'Japanese': 'jp',
      'Kenyan': 'ke',
      'Malaysian': 'my',
      'Mexican': 'mx',
      'Moroccan': 'ma',
      'Polish': 'pl',
      'Portuguese': 'pt',
      'Russian': 'ru',
      'Spanish': 'es',
      'Thai': 'th',
      'Tunisian': 'tn',
      'Turkish': 'tr',
      'Ukrainian': 'ua',
      'Vietnamese': 'vn',
    };

    final code = countryCodes[country] ?? 'unknown';
    return 'https://www.themealdb.com/images/icons/flags/big/64/$code.png';
  }
}
