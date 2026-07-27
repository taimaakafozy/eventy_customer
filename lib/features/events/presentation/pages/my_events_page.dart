import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/utils/event_status_helper.dart';
import 'package:eventy_customer/core/widgets/app_search_field.dart';
import 'package:eventy_customer/core/widgets/emptyview_data.dart';
import 'package:eventy_customer/core/widgets/errorview_data.dart';
import 'package:eventy_customer/core/widgets/primary_filter_chip.dart';
import 'package:eventy_customer/features/events/data/models/get_all_events_model.dart';
import 'package:eventy_customer/features/events/presentation/blocs/get_All_Events/Get_All_Events_Cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/get_All_Events/get_all_events_state.dart';
import 'package:eventy_customer/features/events/presentation/pages/create_event_page.dart';
import 'package:eventy_customer/features/events/presentation/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const List<String?> _statusFilters = [null, "ACTIVE", "DRAFT", "IN_PROGRESS", "COMPLETED", "CANCELLED"];

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  _MyEventsView();
  }
}

class _MyEventsView extends StatefulWidget {
  const _MyEventsView();

  @override
  State<_MyEventsView> createState() => _MyEventsViewState();
}

class _MyEventsViewState extends State<_MyEventsView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 220) {
      sl<GetAllEventsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<EventItem> _applySearch(List<EventItem> events) {
    if (_searchQuery.trim().isEmpty) return events;
    final q = _searchQuery.trim().toLowerCase();
    return events.where((e) => e.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("My Events")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateEventPage())),
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: AppSearchField(
              controller: _searchController,
              hintText: "Search your events...",
              onChanged: (v) => setState(() => _searchQuery = v),
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
                final selected = sl<GetAllEventsCubit>().currentStatus == status;

                return FiltersChip(
                  label: status == null ? "All" : EventStatusHelper.displayName(status),
                  selected: selected,
                  onTap: () => sl<GetAllEventsCubit>().loadEvents(status: status),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<GetAllEventsCubit, GetAllEventsState>(
               bloc: sl<GetAllEventsCubit>(),
              builder: (context, state) {
                if (state is GetAllEventsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GetAllEventsError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () => sl<GetAllEventsCubit>().refresh(),
                  );
                }

                if (state is GetAllEventsLoaded) {
                  final filtered = _applySearch(state.events);

                  if (filtered.isEmpty) {
                    return EmptyView(
                      title: "No events found",
                      message: _searchQuery.isNotEmpty
                          ? "Try a different search term"
                          : "Create your first event to get started",
                      icon: Icons.event_busy_rounded,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => sl<GetAllEventsCubit>().refresh(),
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 90),
                      itemCount: filtered.length + (state.hasReachedEnd ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == filtered.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return EventCard(event: filtered[index]);
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