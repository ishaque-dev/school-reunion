import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/batch.dart';
import '../bloc/alumni_list_bloc.dart';
import '../widgets/alumni_card.dart';
import '../widgets/alumni_detail_dialog.dart';
import 'register_page.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({super.key});

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<AlumniListBloc>();
    _searchCtrl.text = bloc.state.search;
    bloc.add(const AlumniListLoaded());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        context.read<AlumniListBloc>().add(AlumniListSearchChanged(value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(isMobile: isMobile),
            _SearchBar(
              controller: _searchCtrl,
              isMobile: isMobile,
              onChanged: _onSearchChanged,
              onClear: () {
                _searchCtrl.clear();
                _debounce?.cancel();
                context.read<AlumniListBloc>().add(const AlumniListSearchChanged(''));
              },
            ),
            const _FilterRow(),
            Expanded(child: _AlumniGrid(isMobile: isMobile)),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isMobile;
  const _Header({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(isMobile ? 16 : 40, 20, isMobile ? 16 : 40, 12),
      child: Row(
        children: [
          IconButton.filled(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alumni Directory',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                BlocBuilder<AlumniListBloc, AlumniListState>(
                  builder: (context, state) {
                    final n = state.sortedAlumni.length;
                    return Text(
                      '$n ${n == 1 ? 'alumnus' : 'alumni'} found',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (!isMobile)
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RegisterPage()),
              ),
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text('Register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
            )
          else
            IconButton.filled(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RegisterPage()),
              ),
              icon: const Icon(Icons.person_add_alt_1_rounded),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(12),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isMobile;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.isMobile,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: 'Search by name, city, occupation, company...',
                  hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: onClear,
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const _SortMenu(),
        ],
      ),
    );
  }
}

class _SortMenu extends StatelessWidget {
  const _SortMenu();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlumniListBloc, AlumniListState>(
      builder: (context, state) {
        return PopupMenuButton<SortBy>(
          tooltip: 'Sort by',
          onSelected: (s) => context.read<AlumniListBloc>().add(AlumniListSortChanged(s)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          itemBuilder: (_) => SortBy.values
              .map((s) => PopupMenuItem(
                    value: s,
                    child: Row(
                      children: [
                        Icon(
                          state.sortBy == s ? Icons.check_circle : Icons.circle_outlined,
                          color: state.sortBy == s ? AppColors.primary : AppColors.textSecondary,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(s.label),
                      ],
                    ),
                  ))
              .toList(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.sort_rounded, size: 18, color: AppColors.textPrimary),
                const SizedBox(width: 6),
                Text(
                  state.sortBy.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return BlocBuilder<AlumniListBloc, AlumniListState>(
      builder: (context, state) {
        return Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _FilterChip(
                label: 'All Batches',
                selected: state.batchFilter == null,
                color: AppColors.primary,
                onTap: () => context
                    .read<AlumniListBloc>()
                    .add(const AlumniListBatchFilterChanged(null)),
              ),
              const SizedBox(width: 8),
              for (final b in Batch.values) ...[
                _FilterChip(
                  label: b.displayName,
                  selected: state.batchFilter == b,
                  color: b.color,
                  icon: b.icon,
                  onTap: () => context.read<AlumniListBloc>().add(
                        AlumniListBatchFilterChanged(state.batchFilter == b ? null : b),
                      ),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final IconData? icon;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.color,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? color : Colors.white,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: selected ? color : AppColors.border),
            boxShadow: selected
                ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 14, offset: const Offset(0, 4))]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: selected ? Colors.white : color),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlumniGrid extends StatelessWidget {
  final bool isMobile;
  const _AlumniGrid({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlumniListBloc, AlumniListState>(
      builder: (context, state) {
        final list = state.sortedAlumni;
        if (state.status == AlumniListStatus.loading && list.isEmpty) {
          return _LoadingGrid(isMobile: isMobile);
        }
        if (state.status == AlumniListStatus.failure && list.isEmpty) {
          return _ErrorState(
            error: state.errorMessage ?? 'Failed to load',
            onRetry: () => context.read<AlumniListBloc>().add(const AlumniListRefreshed()),
          );
        }
        if (list.isEmpty) {
          final hasFilters = state.search.isNotEmpty || state.batchFilter != null;
          return _EmptyState(hasFilters: hasFilters);
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<AlumniListBloc>().add(const AlumniListRefreshed());
          },
          child: GridView.builder(
            padding: EdgeInsets.fromLTRB(isMobile ? 16 : 40, 16, isMobile ? 16 : 40, 40),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.gridColumns(context),
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              mainAxisExtent: 290,
            ),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final a = list[i];
              return AlumniCard(
                alumni: a,
                onTap: () => AlumniDetailDialog.show(context, a),
              );
            },
          ),
        );
      },
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  final bool isMobile;
  const _LoadingGrid({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(isMobile ? 16 : 40, 16, isMobile ? 16 : 40, 40),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.gridColumns(context),
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        mainAxisExtent: 290,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasFilters;
  const _EmptyState({required this.hasFilters});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
              child: Icon(
                hasFilters
                    ? Icons.search_off_rounded
                    : Icons.person_off_outlined,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              hasFilters ? 'No matches found' : 'No one is here yet',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Try a different search or pick another batch.'
                  : 'Be the first to register and let your classmates find you.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            if (!hasFilters) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                ),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text('Register Yourself'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(0.1),
              ),
              child: const Icon(Icons.cloud_off_rounded, size: 50, color: AppColors.secondary),
            ),
            const SizedBox(height: 20),
            const Text('Unable to load alumni',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            const Text(
              'Make sure the backend is running on http://localhost:8080',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
