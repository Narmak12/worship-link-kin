import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../providers/search_provider.dart';
import '../../widgets/common/app_scaffold.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commune = ref.watch(searchCommuneProvider);
    final category = ref.watch(searchCategoryProvider);
    final available = ref.watch(searchAvailabilityProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    return AppScaffold(
      title: 'Rechercher un talent',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(hintText: 'Nom, description...', prefixIcon: Icon(Icons.search)),
              onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterDropdown<String>(
                  hint: 'Commune',
                  value: commune,
                  items: AppConstants.kinshasaCommunes,
                  onChanged: (v) => ref.read(searchCommuneProvider.notifier).state = v,
                ),
                const SizedBox(width: 8),
                _FilterDropdown<String>(
                  hint: 'Spécialité',
                  value: category,
                  items: AppConstants.talentCategories,
                  onChanged: (v) => ref.read(searchCategoryProvider.notifier).state = v,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Disponible uniquement'),
                  selected: available == true,
                  onSelected: (selected) => ref.read(searchAvailabilityProvider.notifier).state = selected ? true : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: resultsAsync.when(
              data: (results) {
                if (results.isEmpty) {
                  return Center(child: Text('Aucun résultat', style: GoogleFonts.inter(color: AppColors.slateMuted)));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final talent = results[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [AppShadows.level1]),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundImage: talent['avatar_url'] != null ? NetworkImage(talent['avatar_url'] as String) : null,
                          child: talent['avatar_url'] == null ? const Icon(Icons.person) : null,
                        ),
                        title: Text(talent['full_name'] as String? ?? '', style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
                        subtitle: Text(talent['commune'] as String? ?? '', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateMuted)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/talent/${talent['id']}'),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur : $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;

  const _FilterDropdown({required this.hint, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.divider)),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateMuted)),
          items: [
            DropdownMenuItem<T>(value: null, child: Text('Tous', style: GoogleFonts.inter(fontSize: 12))),
            ...items.map((item) => DropdownMenuItem<T>(value: item, child: Text(item.toString(), style: GoogleFonts.inter(fontSize: 12)))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
