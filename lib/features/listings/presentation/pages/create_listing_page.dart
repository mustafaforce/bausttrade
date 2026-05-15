import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/design/meta_colors.dart';
import '../../../../core/design/meta_radius.dart';
import '../../../../core/design/meta_spacing.dart';
import '../../../../core/design/meta_typography.dart';
import '../../../../core/design/widgets/meta_buttons.dart';
import '../../../../core/design/widgets/meta_inputs.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/listing.dart';
import '../controllers/listing_bloc.dart';

class CreateListingPage extends StatefulWidget {
  final Listing? listing;

  const CreateListingPage({super.key, this.listing});

  bool get isEditMode => listing != null;

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String? _selectedCategoryId;
  File? _selectedImage;
  bool _isLoading = false;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    context.read<ListingBloc>().add(GetCategoriesEvent());

    if (widget.isEditMode) {
      _titleController.text = widget.listing!.title;
      _descriptionController.text = widget.listing!.description ?? '';
      _priceController.text = widget.listing!.price.toString();
      _selectedCategoryId = widget.listing!.categoryId;
      _existingImageUrl = widget.listing!.imageUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;

    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${_selectedImage!.path.split('/').last}';
      final bytes = await _selectedImage!.readAsBytes();

      Logger.api('POST', '/storage/listings/$fileName');

      final response = await Supabase.instance.client.storage
          .from('listings')
          .uploadBinary(fileName, bytes);

      if (response.isNotEmpty) {
        final publicUrl = Supabase.instance.client.storage
            .from('listings')
            .getPublicUrl(fileName);
        Logger.success('Image uploaded: $publicUrl');
        return publicUrl;
      }
    } catch (e, st) {
      Logger.error('Image upload failed', error: e, stackTrace: st);
    }
    return null;
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final imageUrl = await _uploadImage();

    if (!mounted) return;

    if (widget.isEditMode) {
      context.read<ListingBloc>().add(UpdateListingEvent(
            id: widget.listing!.id,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            price: double.parse(_priceController.text.trim()),
            categoryId: _selectedCategoryId,
            imageUrl: imageUrl ?? _existingImageUrl,
          ));
    } else {
      context.read<ListingBloc>().add(CreateListingEvent(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            price: double.parse(_priceController.text.trim()),
            categoryId: _selectedCategoryId,
            imageUrl: imageUrl,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit Listing' : 'Create Listing'),
      ),
      body: BlocListener<ListingBloc, ListingState>(
        listener: (context, state) {
          if (state is ListingCreated || state is ListingUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.isEditMode
                    ? 'Listing updated successfully!'
                    : 'Listing created successfully!'),
              ),
            );
            context.read<ListingBloc>().add(GetListingsEvent());
            Navigator.of(context).pop();
          } else if (state is ListingError) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(MetaSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: MetaColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(MetaRadius.xxl),
                      border: Border.all(color: MetaColors.hairline),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(MetaRadius.xxl),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : _existingImageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(MetaRadius.xxl),
                                child: Image.network(
                                  _existingImageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo,
                                      size: 48, color: MetaColors.steel),
                                  const SizedBox(height: MetaSpacing.xs),
                                  Text(
                                    'Tap to add photo',
                                    style: MetaTypography.bodySm.copyWith(
                                      color: MetaColors.steel,
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ),
                const SizedBox(height: MetaSpacing.xl),
                MetaTextInput(
                  controller: _titleController,
                  labelText: 'Title',
                  prefixIcon: const Icon(Icons.title),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: MetaSpacing.base),
                BlocBuilder<ListingBloc, ListingState>(
                  buildWhen: (previous, current) =>
                      current is CategoriesLoaded || current is ListingLoading,
                  builder: (context, state) {
                    final categories = state is CategoriesLoaded
                        ? state.categories
                        : <dynamic>[];

                    return MetaDropdownField(
                      value: _selectedCategoryId,
                      labelText: 'Category',
                      prefixIcon: const Icon(Icons.category),
                      items: categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat.id as String,
                          child: Text(cat.name as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedCategoryId = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: MetaSpacing.base),
                MetaTextInput(
                  controller: _priceController,
                  labelText: 'Price',
                  prefixIcon: const Icon(Icons.attach_money),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: MetaSpacing.base),
                MetaTextInput(
                  controller: _descriptionController,
                  labelText: 'Description (optional)',
                  prefixIcon: const Icon(Icons.description),
                  maxLines: 4,
                ),
                const SizedBox(height: MetaSpacing.xxl),
                MetaPrimaryButton(
                  label: widget.isEditMode ? 'Update Listing' : 'Create Listing',
                  isLoading: _isLoading,
                  onPressed: _onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
