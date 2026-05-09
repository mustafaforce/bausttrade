import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design/meta_colors.dart';
import '../../../../core/design/meta_radius.dart';
import '../../../../core/design/meta_spacing.dart';
import '../../../../core/design/meta_typography.dart';
import '../../../../core/design/widgets/meta_buttons.dart';
import '../../../../core/design/widgets/meta_cards.dart';
import '../../../../core/design/widgets/meta_nav.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/usecases/get_user_by_id_usecase.dart';
import '../../../chat/presentation/controllers/chat_bloc.dart';
import '../../domain/entities/listing.dart';
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
      appBar: MetaAppBar(
        title: 'Listing Details',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MetaSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MetaPhotoCard(
              child: listing.imageUrl != null
                  ? Image.network(
                      listing.imageUrl!,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imagePlaceholder(),
                    )
                  : _imagePlaceholder(),
            ),
            const SizedBox(height: MetaSpacing.lg),
            Text(
              listing.title,
              style: MetaTypography.headingSm,
            ),
            const SizedBox(height: MetaSpacing.xs),
            Text(
              '\$${listing.price.toStringAsFixed(2)}',
              style: MetaTypography.headingMd.copyWith(
                color: MetaColors.inkDeep,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: MetaSpacing.base),
            if (listing.description != null && listing.description!.isNotEmpty) ...[
              Text(
                'Description',
                style: MetaTypography.subtitleLg,
              ),
              const SizedBox(height: MetaSpacing.sm),
              Text(
                listing.description!,
                style: MetaTypography.bodyMd.copyWith(color: MetaColors.charcoal),
              ),
              const SizedBox(height: MetaSpacing.base),
            ],
            FutureBuilder<User>(
              future: _fetchSeller(),
              builder: (context, snapshot) {
                final sellerName = snapshot.data?.name ?? 'Loading...';
                return MetaProductFeatureCard(
                  padding: const EdgeInsets.all(MetaSpacing.base),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: MetaColors.surfaceSoft,
                      child: Icon(Icons.person,
                          color: MetaColors.ink),
                    ),
                    title: Text('Seller', style: MetaTypography.bodySmBold),
                    subtitle: Text(
                      isOwner ? 'You' : sellerName,
                      style: MetaTypography.bodyMd,
                    ),
                    trailing: !isOwner
                        ? const Icon(Icons.chevron_right, color: MetaColors.steel)
                        : null,
                    onTap: isOwner
                        ? null
                        : () => _contactSeller(context, sellerName),
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
                padding: const EdgeInsets.all(MetaSpacing.base),
                child: MetaBuyCtaButton(
                  label: 'Contact Seller',
                  icon: const Icon(Icons.message, size: 18),
                  onPressed: () async {
                    final seller = await _fetchSeller();
                    if (context.mounted) {
                      _contactSeller(context, seller.name);
                    }
                  },
                ),
              ),
            ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 250,
      color: MetaColors.surfaceSoft,
      child: const Center(
        child: Icon(Icons.image, size: 64, color: MetaColors.steel),
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
      'sellerName': sellerName,
    });
  }
}
