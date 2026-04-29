import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../chat/presentation/controllers/chat_bloc.dart';
import '../../domain/entities/listing.dart';
import '../../../auth/domain/usecases/get_user_by_id_usecase.dart';
import '../../../../injection_container.dart';

class ListingDetailPage extends StatelessWidget {
  final Listing listing;
  final User currentUser;

  const ListingDetailPage({
    super.key,
    required this.listing,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final isOwner = listing.userId == currentUser.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (listing.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  listing.imageUrl!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 250,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image, size: 64)),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Icon(Icons.image, size: 64)),
              ),
            const SizedBox(height: 20),
            Text(
              listing.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${listing.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (listing.description != null && listing.description!.isNotEmpty) ...[
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                listing.description!,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
            ],
            FutureBuilder<User>(
              future: _fetchSeller(),
              builder: (context, snapshot) {
                final sellerName = snapshot.data?.name ?? 'Loading...';
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Seller'),
                    subtitle: Text(isOwner ? 'You' : sellerName),
                    trailing: !isOwner
                        ? const Icon(Icons.chevron_right)
                        : null,
                    onTap: isOwner ? null : () => _contactSeller(context, sellerName),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: isOwner
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: () async {
                    final seller = await _fetchSeller();
                    if (context.mounted) {
                      _contactSeller(context, seller.name);
                    }
                  },
                  icon: const Icon(Icons.message),
                  label: const Text('Contact Seller'),
                ),
              ),
            ),
    );
  }

  Future<User> _fetchSeller() async {
    final getUserById = sl<GetUserByIdUseCase>();
    final result = await getUserById(listing.userId);
    return result.fold(
      (failure) => User(
        id: listing.userId,
        email: '',
        name: 'Unknown',
        createdAt: DateTime.now(),
      ),
      (user) => user,
    );
  }

  void _contactSeller(BuildContext context, String sellerName) {
    context.read<ChatBloc>().add(GetOrCreateConversationEvent(
      listingId: listing.id,
      buyerId: currentUser.id,
      buyerName: currentUser.name,
      sellerId: listing.userId,
      sellerName: sellerName,
    ));

    Navigator.pushNamed(context, '/chat', arguments: {
      'listing': listing,
      'otherUserId': listing.userId,
    });
  }
}