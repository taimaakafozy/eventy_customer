import 'dart:async';

import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/widgets/app_search_field.dart';
import 'package:eventy_customer/core/widgets/emptyview_data.dart';
import 'package:eventy_customer/core/widgets/errorview_data.dart';
import 'package:eventy_customer/core/widgets/primary_filter_chip.dart';
import 'package:eventy_customer/features/complaints/presentation/blocs/complaints_list/complaints_list_cubit.dart';
import 'package:eventy_customer/features/complaints/presentation/blocs/complaints_list/complaints_list_state.dart';
import 'package:eventy_customer/features/complaints/presentation/pages/complaint_details_page.dart';
import 'package:eventy_customer/features/complaints/presentation/pages/create_complaint_page.dart';
import 'package:eventy_customer/features/complaints/presentation/widgets/complaint_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const List<String?> _statusFilters = [null, "PENDING", "IN_PROGRESS", "RESOLVED", "REJECTED"];

class ComplaintsPage extends StatelessWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ComplaintsListCubit>()..loadComplaints(),
      child: const _ComplaintsView(),
    );
  }
}

class _ComplaintsView extends StatefulWidget {
  const _ComplaintsView();

  @override
  State<_ComplaintsView> createState() => _ComplaintsViewState();
}

class _ComplaintsViewState extends State<_ComplaintsView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _selectedStatus;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 220) {
      context.read<ComplaintsListCubit>().loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ComplaintsListCubit>().loadComplaints(status: _selectedStatus, search: value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateComplaintPage()),
    );
    if (result == true && mounted) {
      context.read<ComplaintsListCubit>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("My Complaints")),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreate,
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: AppSearchField(
              controller: _searchController,
              hintText: "Search complaints...",
              onChanged: _onSearchChanged,
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _statusFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, index) {
                final status = _statusFilters[index];
                final selected = _selectedStatus == status;

                return FiltersChip(
                  label: status == null ? "All" : status[0] + status.substring(1).toLowerCase().replaceAll('_', ' '),
                  selected: selected,
                  onTap: () {
                    setState(() => _selectedStatus = status);
                    context.read<ComplaintsListCubit>().loadComplaints(
                          status: status,
                          search: _searchController.text,
                        );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<ComplaintsListCubit, ComplaintsListState>(
              builder: (context, state) {
                if (state is ComplaintsListLoading || state is ComplaintsListInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ComplaintsListError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () => context.read<ComplaintsListCubit>().refresh(),
                  );
                }

                if (state is ComplaintsListLoaded) {
                  if (state.items.isEmpty) {
                    return const EmptyView(
                      title: "No complaints yet",
                      message: "If something's wrong, let us know and we'll help you out",
                      icon: Icons.support_agent_rounded,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => context.read<ComplaintsListCubit>().refresh(),
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 90),
                      itemCount: state.items.length + (state.hasReachedEnd ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == state.items.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final complaint = state.items[index];
                        return ComplaintCard(
                          complaint: complaint,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ComplaintDetailsPage(complaintId: complaint.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}