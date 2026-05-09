import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/design/meta_colors.dart';
import '../../../../core/design/meta_radius.dart';
import '../../../../core/design/meta_spacing.dart';
import '../../../../core/design/meta_typography.dart';
import '../../../../core/utils/logger.dart';
import '../../../listings/domain/entities/listing.dart';
import '../../../listings/presentation/controllers/listing_bloc.dart';
import '../../../listings/presentation/pages/create_listing_page.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  List<Map<String, dynamic>> _myListings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyListings();
  }

  Future<void> _loadMyListings() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      Logger.api('GET', '/listings?user_id=eq.$userId');

      final response = await Supabase.instance.client
          .from('listings')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      Logger.success('Fetched ${response.length} my listings');

      setState(() {
        _myListings = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e, st) {
      Logger.error('Failed to load listings', error: e, stackTrace: st);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteListing(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Listing'),
        content: const Text('Are you sure you want to delete this listing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: MetaColors.critical)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        context.read<ListingBloc>().add(DeleteListingEvent(id));
        await _loadMyListings();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Listing deleted')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _myListings.isEmpty
              ? Center(
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
                        'Tap + to create your first listing',
                        style: MetaTypography.bodyMd.copyWith(
                          color: MetaColors.steel,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadMyListings,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(MetaSpacing.base),
                    itemCount: _myListings.length,
                    itemBuilder: (context, index) {
                      final listing = _myListings[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: MetaSpacing.md),
                        decoration: BoxDecoration(
                          color: MetaColors.canvas,
                          borderRadius: BorderRadius.circular(MetaRadius.xl),
                          border: Border.all(color: MetaColors.hairlineSoft),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(MetaSpacing.md),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(MetaRadius.lg),
                            child: listing['image_url'] != null
                                ? Image.network(
                                    listing['image_url'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _imagePlaceholder(),
                                  )
                                : _imagePlaceholder(),
                          ),
                          title: Text(
                            listing['title'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: MetaTypography.bodyMdBold,
                          ),
                          subtitle: Text(
                            '\$${listing['price']}',
                            style: MetaTypography.bodySmBold.copyWith(
                              color: MetaColors.inkDeep,
                            ),
                          ),
                          trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert,
                                color: MetaColors.steel),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: MetaColors.ink),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete,
                                        color: MetaColors.critical),
                                    SizedBox(width: 8),
                                    Text('Delete',
                                        style:
                                            TextStyle(color: MetaColors.critical)),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                final listingEntity = Listing(
                                  id: listing['id'],
                                  userId: listing['user_id'],
                                  categoryId: listing['category_id'],
                                  title: listing['title'],
                                  description: listing['description'],
                                  price:
                                      (listing['price'] as num).toDouble(),
                                  imageUrl: listing['image_url'],
                                  status: listing['status'] ?? 'active',
                                  createdAt: DateTime.parse(
                                      listing['created_at']),
                                  updatedAt: DateTime.parse(
                                      listing['updated_at']),
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<ListingBloc>(),
                                      child: CreateListingPage(
                                          listing: listingEntity),
                                    ),
                                  ),
                                );
                              } else if (value == 'delete') {
                                _deleteListing(listing['id']);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: MetaColors.surfaceSoft,
      child: const Icon(Icons.image, color: MetaColors.steel),
    );
  }
}
