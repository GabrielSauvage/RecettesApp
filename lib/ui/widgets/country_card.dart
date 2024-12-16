import 'package:flutter/material.dart';
import '../../models/country.dart';

class CountryCard extends StatelessWidget {
  final Country country;

  const CountryCard({required this.country});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            country.strArea,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}