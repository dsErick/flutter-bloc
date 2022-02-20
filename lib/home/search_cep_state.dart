abstract class SearchCepState {}

class SearchCepEmpty implements SearchCepState {
  const SearchCepEmpty();
}

class SearchCepSuccess implements SearchCepState {
  final Map<String, dynamic> data;

  const SearchCepSuccess(this.data);
}

class SearchCepLoading implements SearchCepState {
  const SearchCepLoading();
}

class SearchCepError implements SearchCepState {
  final String message;

  const SearchCepError(this.message);
}
