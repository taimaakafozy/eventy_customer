import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/utils/service_type_helper.dart';
import 'package:eventy_customer/core/widgets/app_search_field.dart';
import 'package:eventy_customer/core/widgets/primary_filter_chip.dart';
import 'package:eventy_customer/features/services/data/models/service_type_model.dart';
import 'package:eventy_customer/features/services/presentation/blocs/available_services/available_services_cubit.dart';
import 'package:eventy_customer/features/services/presentation/blocs/available_services/available_services_state.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_details/service_details_cubit.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_types/service_types_cubit.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_types/service_types_state.dart';
import 'package:eventy_customer/features/services/presentation/pages/service_details_page.dart';
import 'package:eventy_customer/features/services/presentation/widgets/services/service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicesPage extends StatefulWidget {
  final ServiceTypeModel? selectedType;

  const ServicesPage({
    super.key,
    this.selectedType,
  });

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late final ScrollController _controller;

  late final TextEditingController _searchController;

  List<ServiceTypeModel> _types = [];

  ServiceTypeModel? _selectedType;

  @override
void initState() {
  super.initState();

  _searchController = TextEditingController();

  _controller = ScrollController()
    ..addListener(_loadMore);

  _selectedType = widget.selectedType;
}

  void _loadServices() {
    context.read<AvailableServicesCubit>().loadServices(
          _selectedType?.name,
        );
  }

  void _loadMore() {
    if (!_controller.hasClients) return;

    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 220) {
      context.read<AvailableServicesCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          _selectedType == null
              ? "Services"
              : ServiceTypeHelper.displayName(
                  _selectedType!.name,
                ),
        ),
      ),

      body: Column(
        children: [

          /// Search + Filters
          BlocBuilder<ServiceTypesCubit, ServiceTypesState>(
            builder: (context, typeState) {

              if (typeState is ServiceTypesSuccess) {
                _types = typeState.serviceTypes;
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  10,
                ),
                child: Column(
                  children: [

                    AppSearchField(
                      controller: _searchController,
                      hintText: "Search brands...",
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      height: 42,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [

                          FiltersChip(
                            label: "All",
                            selected: _selectedType == null,
                            onTap: () {

                              setState(() {
                                _selectedType = null;
                              });

                              _loadServices();
                            },
                          ),

                          const SizedBox(width: 10),

                          ..._types.map(
                            (type) => Padding(
                              padding:
                                  const EdgeInsets.only(right: 10),
                              child: FiltersChip(
                                label: ServiceTypeHelper.displayName(
                                  type.name,
                                ),

                                selected:
                                    _selectedType?.id == type.id,

                                onTap: () {

                                  setState(() {
                                    _selectedType = type;
                                  });

                                  _loadServices();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Expanded(
            child: BlocBuilder<
                AvailableServicesCubit,
                AvailableServicesState>(
              builder: (context, state) {

                if (state is AvailableServicesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is AvailableServicesError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                if (state is AvailableServicesLoaded) {

                  if (state.services.isEmpty) {
                    return const Center(
                      child: Text(
                        "No services found",
                      ),
                    );
                  }

                  return RefreshIndicator(

                    onRefresh: () async {
                      _loadServices();
                    },

                    child: ListView.builder(

                      controller: _controller,

                      physics:
                          const BouncingScrollPhysics(),

                      padding: const EdgeInsets.fromLTRB(
                        20,
                        12,
                        20,
                        24,
                      ),

                      itemCount:
                          state.services.length +
                          (state.hasReachedEnd ? 0 : 1),

                      itemBuilder: (context, index) {

                        if (index ==
                            state.services.length) {

                          return const Padding(
                            padding:
                                EdgeInsets.symmetric(
                              vertical: 24,
                            ),
                            child: Center(
                              child:
                                  CircularProgressIndicator(),
                            ),
                          );
                        }

                        final service =
                            state.services[index];

                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 22,
                          ),
                          child: ServiceCard(
                            service: service,
                           onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute( 
      builder: (_) => BlocProvider(
        create: (_) => sl<ServiceDetailsCubit>(),  
        child: ServiceDetailsPage(serviceId: service.id),
      ),
    ),
  );
},
                          ),
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