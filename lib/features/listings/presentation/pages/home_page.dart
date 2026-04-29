import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                prefixText: '\$ ',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: maxController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Max Price',
                prefixText: '\$ ',
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
      builder: (context, state) {
        final user = state is auth.Authenticated ? state.user : null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Baust CampusTrade'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: BlocBuilder<ListingBloc, ListingState>(
                  builder: (context, state) {
                    final categories = state is CategoriesLoaded ? state.categories : [];
                    return DropdownButtonHideUnderline(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedCategoryId,
                          hint: const Text('All Categories'),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('All Categories'),
                            ),
                            ...categories.map((cat) => DropdownMenuItem(
                              value: cat.id as String,
                              child: Text(cat.name as String),
                            )),
                          ],
                          onChanged: _onCategorySelected,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: _ListingSearchDelegate(
                      listingBloc: context.read<ListingBloc>(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Badge(
                  isLabelVisible: _minPrice != null || _maxPrice != null,
                  child: const Icon(Icons.filter_list),
                ),
                onPressed: _showPriceFilterDialog,
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<auth.AuthBloc>().add(auth.LogoutEvent());
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  accountName: Text(user?.name ?? 'User'),
                  accountEmail: Text(user?.email ?? ''),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: user?.avatarUrl != null
                        ? NetworkImage(user!.avatarUrl!)
                        : null,
                    child: user?.avatarUrl == null
                        ? Text(user?.name.substring(0, 1).toUpperCase() ?? 'U')
                        : null,
                  ),
                  onDetailsPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.inventory_2),
                  title: const Text('My Listings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/my-listings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.message),
                  title: const Text('Messages'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/conversations');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    context.read<auth.AuthBloc>().add(auth.LogoutEvent());
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
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
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No listings yet',
                          style: TextStyle(
                              fontSize: 18, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to post something!',
                          style: TextStyle(color: Colors.grey[500]),
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
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: listingState.listings.length,
                    itemBuilder: (context, index) {
                      final listing = listingState.listings[index];
                      return _ListingCard(
                        listing: listing,
                        onTap: () {
                          final authState = context.read<auth.AuthBloc>().state;
                          if (authState is auth.Authenticated) {
                            Navigator.pushNamed(context, '/listing-detail', arguments: {
                              'listing': listing,
                              'currentUser': authState.user,
                            });
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
                          size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load listings',
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
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

class _ListingCard extends StatelessWidget {
  final dynamic listing;
  final VoidCallback? onTap;

  const _ListingCard({required this.listing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: listing.imageUrl != null
                        ? Image.network(
                            listing.imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, size: 40),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.image, size: 40, color: Colors.grey),
                            ),
                          ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listing.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${listing.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            listing.categoryId ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
               )         ),
    );
  }
}

class _ListingSearchDelegate extends SearchDelegate<String> {
  final ListingBloc listingBloc;

  _ListingSearchDelegate({required this.listingBloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
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
              child: Text('No results for "$query"'),
            );
          }

          return ListView.builder(
            itemCount: state.listings.length,
            itemBuilder: (context, index) {
              final listing = state.listings[index];
              return ListTile(
                leading: listing.imageUrl != null
                    ? Image.network(listing.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.image),
                title: Text(listing.title),
                subtitle: Text('\$${listing.price.toStringAsFixed(2)}'),
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
    return const Center(
      child: Text('Search for listings by title or description'),
    );
  }
}