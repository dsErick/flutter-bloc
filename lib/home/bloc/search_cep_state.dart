part of 'search_cep_bloc.dart';

abstract class SearchCepState {}

class SearchCepEmpty implements SearchCepState {
  const SearchCepEmpty();
}

class SearchCepSuccess extends Equatable implements SearchCepState {
  final Map<String, dynamic> data;

  const SearchCepSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class SearchCepLoading implements SearchCepState {
  const SearchCepLoading();
}

class SearchCepError extends Equatable implements SearchCepState {
  final String message;

  const SearchCepError(this.message);

  @override
  List<Object?> get props => [message];
}
