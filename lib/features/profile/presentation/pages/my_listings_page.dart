import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No listings yet',
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to create your first listing',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadMyListings,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _myListings.length,
                    itemBuilder: (context, index) {
                      final listing = _myListings[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: listing['image_url'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    listing['image_url'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image),
                                ),
                          title: Text(
                            listing['title'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '\$${listing['price']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete',
                                        style: TextStyle(color: Colors.red)),
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
                                  price: (listing['price'] as num).toDouble(),
                                  imageUrl: listing['image_url'],
                                  status: listing['status'] ?? 'active',
                                  createdAt: DateTime.parse(listing['created_at']),
                                  updatedAt: DateTime.parse(listing['updated_at']),
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<ListingBloc>(),
                                      child: CreateListingPage(listing: listingEntity),
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
}
