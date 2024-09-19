import 'package:flutter/material.dart';
import 'package:medgis_app/page/bloc/main_cubit.dart';
import 'package:medgis_app/page/bloc/main_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/view/home/bloc/home_cubit.dart';
import 'package:medgis_app/view/home/bloc/home_state.dart';
import 'package:medgis_app/view/home/widgets/chart.dart';
import 'package:medgis_app/view/home/widgets/main_table.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(_onSearchChanged);
    context.read<HomeCubit>().fetchAllPatients();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<HomeCubit>().filterPatients(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const CircularProgressIndicator();
            } else if (state is HomeSuccess) {
              return Chart(
                totalPatients: state.totalPatients,
                malePatients: state.malePatients,
                femalePatients: state.femalePatients,
              );
            } else if (state is HomeFailure) {
              return Text(state.message);
            } else {
              return const Text('No Data');
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            TextButton(
              onPressed: () =>
                  context.read<MainCubit>().setState(AddPatientViewState()),
              child: const Row(
                children: [
                  Icon(Icons.add_rounded),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Add Patient")
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const CircularProgressIndicator();
            } else if (state is HomeSuccess) {
              return MainTable(
                initialized: false,
                patients: state.filteredPatients,
              );
            } else if (state is HomeFailure) {
              return Text(state.message);
            } else {
              return const Text('No Data');
            }
          },
        ),
      ],
    );
  }
}
