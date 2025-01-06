import 'package:bloc/bloc.dart';
import '../models/country.dart';
import '../repositories/country_repository.dart';

class CountryCubit extends Cubit<List<Country>?> {
  final CountryRepository countryRepository;

  CountryCubit({required this.countryRepository}) : super(null);

  Future<void> fetchCountries() async {
    try {
      final countries = await countryRepository.fetchCountries();
      emit(countries);
    } catch (e) {
      emit([]);
    }
  }
}