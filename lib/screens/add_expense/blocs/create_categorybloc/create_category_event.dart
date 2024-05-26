part of 'create_category_bloc.dart';

class CreateCategoryEvent extends Equatable {
  const CreateCategoryEvent();

  @override
  List<Object> get props => [];
}

class CreateCategory extends CreateCategoryEvent {
  final Category category;
  CreateCategory(this.category);
  @override
  List<Object> get props => [category];
}
