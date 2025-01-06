import 'package:bloc/bloc.dart';
import '../models/category.dart';
import '../repositories/category_repository.dart';

class CategoryCubit extends Cubit<List<Category>?> {
  final CategoryRepository categoryRepository;

  CategoryCubit({required this.categoryRepository}) : super(null);

  Future<void> fetchCategories() async {
    try {
      final categories = await categoryRepository.fetchCategories();
      emit(categories);
    } catch (e) {
      emit([]);
    }
  }
}