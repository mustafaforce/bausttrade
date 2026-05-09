import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design/meta_colors.dart';
import '../../../../core/design/meta_spacing.dart';
import '../../../../core/design/meta_radius.dart';
import '../../../../core/design/meta_typography.dart';
import '../../../../core/design/widgets/meta_buttons.dart';
import '../../../../core/design/widgets/meta_cards.dart';
import '../../../../core/design/widgets/meta_nav.dart';
import '../../../auth/presentation/controllers/auth_bloc.dart' as auth;
import '../controllers/listing_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedCategoryId;
  double? _minPrice;
  double? _maxPrice;

  @override
  void initState() {
    super.initState();
    context.read<ListingBloc>().add(GetCategoriesEvent());
    context.read<ListingBloc>().add(GetListingsEvent());
  }

  void _onCategorySelected(String? categoryId) {
    setState(() => _selectedCategoryId = categoryId);
    if (categoryId != null) {
      context.read<ListingBloc>().add(GetListingsByCategoryEvent(categoryId));
    } else {
      context.read<ListingBloc>().add(GetListingsEvent());
    }
  }

  void _showPriceFilterDialog() {
    final minController = TextEditingController(
      text: _minPrice?.toStringAsFixed(0) ?? '',
    );
    final maxController = TextEditingController(
      text: _maxPrice?.toStringAsFixed(0) ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Price'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: minController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Min Price',
                prefixText: '৳ ',
              ),
            ),
            const SizedBox(height: MetaSpacing.md),
            TextField(
              controller: maxController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Max Price',
                prefixText: '৳ ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _minPrice = null;
                _maxPrice = null;
              });
              Navigator.pop(context);
              _applyPriceFilter(null, null);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final min = double.tryParse(minController.text);
              final max = double.tryParse(maxController.text);
              setState(() {
                _minPrice = min;
                _maxPrice = max;
              });
              Navigator.pop(context);
              _applyPriceFilter(min, max);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _applyPriceFilter(double? min, double? max) {
    context.read<ListingBloc>().add(FilterListingsEvent(
      categoryId: _selectedCategoryId,
      minPrice: min,
      maxPrice: max,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<auth.AuthBloc, auth.AuthState>(
      builder: (context, authState) {
        final user = authState is auth.Authenticated ? authState.user : null;

        return Scaffold(
          appBar: MetaAppBar(
            title: 'Baust CampusTrade',
            showBack: false,
            actions: [
              MetaIconCircularButton(
                icon: Icons.search,
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: _ListingSearchDelegate(
                      listingBloc: context.read<ListingBloc>(),
                    ),
                  );
                },
              ),
              MetaIconCircularButton(
                icon: Icons.filter_list,
                onPressed: _showPriceFilterDialog,
              ),
              MetaIconCircularButton(
                icon: Icons.logout,
                onPressed: () {
                  context.read<auth.AuthBloc>().add(auth.LogoutEvent());
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ],
            bottom: Padding(
              padding: const EdgeInsets.symmetric(horizontal: MetaSpacing.base, vertical: MetaSpacing.xs),
              child: BlocBuilder<ListingBloc, ListingState>(
                builder: (context, state) {
                  final categories = state is CategoriesLoaded ? state.categories : <dynamic>[];
                  return SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        MetaPillTab(
                          label: 'All',
                          isActive: _selectedCategoryId == null,
                          onTap: () => _onCategorySelected(null),
                        ),
                        const SizedBox(width: MetaSpacing.xs),
                        ...categories.map((cat) => Padding(
                          padding: const EdgeInsets.only(right: MetaSpacing.xs),
                          child: MetaPillTab(
                            label: cat.name as String,
                            isActive: _selectedCategoryId == cat.id as String,
                            onTap: () => _onCategorySelected(cat.id as String),
                          ),
                        )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          drawer: MetaDrawer(
            userName: user?.name,
            userEmail: user?.email,
            avatarUrl: user?.avatarUrl,
            onProfileTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
            onMyListingsTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/my-listings');
            },
            onMessagesTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/conversations');
            },
            onLogoutTap: () {
              context.read<auth.AuthBloc>().add(auth.LogoutEvent());
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          body: BlocBuilder<ListingBloc, ListingState>(
            builder: (context, listingState) {
              if (listingState is ListingLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (listingState is ListingsLoaded) {
                if (listingState.listings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 64, color: MetaColors.steel),
                        const SizedBox(height: MetaSpacing.base),
                        Text(
                          'No listings yet',
                          style: MetaTypography.headingSm.copyWith(
                            color: MetaColors.charcoal,
                          ),
                        ),
                        const SizedBox(height: MetaSpacing.xs),
                        Text(
                          'Be the first to post something!',
                          style: MetaTypography.bodyMd.copyWith(
                            color: MetaColors.steel,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ListingBloc>().add(GetListingsEvent());
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(MetaSpacing.base),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: MetaSpacing.md,
                      mainAxisSpacing: MetaSpacing.md,
                    ),
                    itemCount: listingState.listings.length,
                    itemBuilder: (context, index) {
                      final listing = listingState.listings[index];
                      return MetaListingCard(
                        imageUrl: listing.imageUrl,
                        title: listing.title,
                        price: '৳${listing.price.toStringAsFixed(2)}',
                        subtitle: listing.categoryId,
                        onTap: () {
                          final authState = context.read<auth.AuthBloc>().state;
                          if (authState is auth.Authenticated) {
                            Navigator.pushNamed(
                              context,
                              '/listing-detail',
                              arguments: {
                                'listing': listing,
                                'currentUser': authState.user,
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              }

              if (listingState is ListingError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: MetaColors.critical),
                      const SizedBox(height: MetaSpacing.base),
                      Text(
                        'Failed to load listings',
                        style: MetaTypography.headingSm.copyWith(
                          color: MetaColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: MetaSpacing.xs),
                      TextButton(
                        onPressed: () {
                          context.read<ListingBloc>().add(GetListingsEvent());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/create-listing');
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class _ListingSearchDelegate extends SearchDelegate<String> {
  final ListingBloc listingBloc;

  _ListingSearchDelegate({required this.listingBloc});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: MetaColors.canvas,
        foregroundColor: MetaColors.inkDeep,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: MetaColors.steel),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      MetaIconCircularButton(
        icon: Icons.clear,
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return MetaIconCircularButton(
      icon: Icons.arrow_back,
      onPressed: () {
        close(context, '');
        listingBloc.add(GetListingsEvent());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isNotEmpty) {
      listingBloc.add(SearchListingsEvent(query.trim()));
    }

    return BlocBuilder<ListingBloc, ListingState>(
      bloc: listingBloc,
      builder: (context, state) {
        if (state is ListingLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ListingsLoaded) {
          if (state.listings.isEmpty) {
            return Center(
              child: Text('No results for "$query"',
                  style: MetaTypography.bodyMd.copyWith(color: MetaColors.steel)),
            );
          }

          return ListView.builder(
            itemCount: state.listings.length,
            itemBuilder: (context, index) {
              final listing = state.listings[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(MetaRadius.lg),
                  child: listing.imageUrl != null
                      ? Image.network(
                          listing.imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          color: MetaColors.surfaceSoft,
                          child: const Icon(Icons.image, color: MetaColors.steel),
                        ),
                ),
                title: Text(listing.title, style: MetaTypography.bodyMdBold),
                subtitle: Text(
                  '৳${listing.price.toStringAsFixed(2)}',
                  style: MetaTypography.bodySm.copyWith(color: MetaColors.inkDeep),
                ),
                onTap: () {
                  close(context, listing.id);
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      return buildResults(context);
    }
    return Center(
      child: Text(
        'Search for listings by title or description',
        style: MetaTypography.bodyMd.copyWith(color: MetaColors.steel),
      ),
    );
  }
}
