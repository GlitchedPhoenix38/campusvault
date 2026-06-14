import 'package:flutter/material.dart';
import 'package:campusvault/data/academic_data.dart';
import 'package:campusvault/models/college.dart';
import 'package:campusvault/models/university.dart';
import 'package:campusvault/screens/program_type_screen.dart';
import 'package:campusvault/utils/route_transitions.dart';
import 'package:campusvault/widgets/breadcrumb_bar.dart';
import 'package:campusvault/widgets/empty_state.dart';
import 'package:campusvault/widgets/search_bar_widget.dart';
import 'package:campusvault/widgets/selection_card.dart';

class CollegeSelectionScreen extends StatefulWidget {
  final University university;

  const CollegeSelectionScreen({super.key, required this.university});

  @override
  State<CollegeSelectionScreen> createState() => _CollegeSelectionScreenState();
}

class _CollegeSelectionScreenState extends State<CollegeSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<College> _allColleges;
  late List<College> _filtered;

  @override
  void initState() {
    super.initState();
    _allColleges = getCollegesForUniversity(widget.university.id);
    _filtered = _allColleges;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _allColleges.where((c) {
        return c.name.toLowerCase().contains(q) ||
            c.shortName.toLowerCase().contains(q);
      }).toList();
    });
  }

  void _onCollegeTapped(College college) {
    Navigator.of(context).push(
      slideRoute(
        ProgramTypeScreen(
          university: widget.university,
          college: college,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select College'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BreadcrumbBar(crumbs: [widget.university.shortName, 'College']),
            SearchBarWidget(
              controller: _searchController,
              hintText: 'Search college…',
              onClear: () => _searchController.clear(),
            ),
            Expanded(
              child: _filtered.isEmpty
                  ? const EmptyState(
                      icon: Icons.account_balance_outlined,
                      message: 'No colleges found',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final college = _filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SelectionCard(
                            title: college.name,
                            subtitle: college.shortName,
                            accentColor: college.accentColor,
                            avatarLabel: college.shortName,
                            onTap: () => _onCollegeTapped(college),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
