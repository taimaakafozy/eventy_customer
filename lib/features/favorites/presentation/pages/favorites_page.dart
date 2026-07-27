import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/widgets/emptyview_data.dart';
import 'package:eventy_customer/core/widgets/errorview_data.dart';
import 'package:eventy_customer/features/favorites/data/models/favorites_list_model.dart';
import 'package:eventy_customer/features/favorites/presentation/blocs/favorite_status/favorite_status_cubit.dart';
import 'package:eventy_customer/features/favorites/presentation/blocs/favorites_list/favorites_list_cubit.dart';
import 'package:eventy_customer/features/favorites/presentation/blocs/favorites_list/favorites_list_state.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_details/service_details_cubit.dart';
import 'package:eventy_customer/features/services/presentation/pages/service_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 220) {
      sl<FavoritesListCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openDetails(String serviceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<ServiceDetailsCubit>(),
          child: ServiceDetailsPage(serviceId: serviceId),
        ),
      ),
    );
  }

  Future<void> _remove(FavoriteItemModel item) async {
  try {
    await sl<FavoriteStatusCubit>().removeFavorite(
      targetType: item.targetType,
      targetId: item.targetId,
    );
    sl<FavoritesListCubit>().removeLocally(item.targetType, item.targetId);
  } catch (_) {}
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Favorites")),
      body: BlocBuilder<FavoritesListCubit, FavoritesListState>(
        bloc: sl<FavoritesListCubit>(),
        builder: (context, state) {
          if (state is FavoritesListLoading || state is FavoritesListInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoritesListError) {
            return ErrorView(
              message: state.message,
              onRetry: () => sl<FavoritesListCubit>().refresh(),
            );
          }

          if (state is FavoritesListLoaded) {
            if (state.items.isEmpty) {
              return const EmptyView(
                title: "No favorites yet",
                message: "Services you love will show up here",
                icon: Icons.favorite_border_rounded,
              );
            }

            return RefreshIndicator(
              onRefresh: () => sl<FavoritesListCubit>().refresh(),
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                itemCount: state.items.length + (state.hasReachedEnd ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index == state.items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final item = state.items[index];
                  return _FavoriteItemCard(
                    item: item,
                    onTap: () => _openDetails(item.targetId),
                    onRemove: () => _remove(item),
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _FavoriteItemCard extends StatelessWidget {
  final FavoriteItemModel item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteItemCard({required this.item, required this.onTap, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final target = item.target;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: target?.serviceLogo != null
                      ? Image.network(
                          target!.serviceLogo!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.room_service_rounded, color: theme.primaryColor),
                        )
                      : Icon(Icons.room_service_rounded, color: theme.primaryColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        target?.description ?? "Service",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            (target?.rating ?? 0) > 0 ? target!.rating.toStringAsFixed(1) : "New",
                            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (target?.price != null) ...[
                            const SizedBox(width: 12),
                            Text(
                              "\$${target!.price!.toStringAsFixed(0)}",
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: AppColors.gold, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_rounded, color: Colors.red),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}