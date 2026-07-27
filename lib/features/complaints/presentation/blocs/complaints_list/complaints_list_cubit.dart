import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/complaint_model.dart';
import '../../../domain/usecases/get_complaints_usecase.dart';
import 'complaints_list_state.dart';

class ComplaintsListCubit extends Cubit<ComplaintsListState> {
  final GetComplaintsUseCase getComplaintsUseCase;
  ComplaintsListCubit(this.getComplaintsUseCase) : super(ComplaintsListInitial());

  final List<ComplaintModel> _items = [];
  int _page = 1;
  final int _limit = 10;
  bool _hasReachedEnd = false;
  bool _isLoading = false;

  String? _status;
  String? _search;

  Future<void> loadComplaints({String? status, String? search}) async {
    if (_isLoading) return;

    _status = status;
    _search = search;
    _page = 1;
    _hasReachedEnd = false;
    _items.clear();
    _isLoading = true;

    emit(ComplaintsListLoading());

    try {
      final response = await getComplaintsUseCase(page: _page, limit: _limit, status: status, search: search);

      _items.addAll(response.items);
      _hasReachedEnd = response.meta.page >= response.meta.totalPages;

      emit(ComplaintsListLoaded(items: List.from(_items), hasReachedEnd: _hasReachedEnd));
    } catch (e) {
      emit(ComplaintsListError(e.toString().replaceFirst('Exception: ', '')));
    }

    _isLoading = false;
  }

  Future<void> loadMore() async {
    if (_isLoading || _hasReachedEnd) return;

    final currentState = state;
    if (currentState is! ComplaintsListLoaded) return;

    _isLoading = true;

    try {
      final response =
          await getComplaintsUseCase(page: _page + 1, limit: _limit, status: _status, search: _search);

      _page = response.meta.page;
      _items.addAll(response.items);
      _hasReachedEnd = response.meta.page >= response.meta.totalPages;

      emit(ComplaintsListLoaded(items: List.from(_items), hasReachedEnd: _hasReachedEnd));
    } catch (_) {}

    _isLoading = false;
  }

  Future<void> refresh() => loadComplaints(status: _status, search: _search);
}