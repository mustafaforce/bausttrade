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
import '../../../auth/presentation/controllers/auth_bloc.dart' as auth;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _selectedAvatar;
  String? _currentAvatarUrl;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final state = context.read<auth.AuthBloc>().state;
    if (state is auth.Authenticated) {
      _nameController.text = state.user.name;
      _phoneController.text = state.user.phone ?? '';
      _currentAvatarUrl = state.user.avatarUrl;
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedAvatar = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadAvatar() async {
    if (_selectedAvatar == null) return null;

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final fileName = 'avatars/$userId.jpg';
      final bytes = await _selectedAvatar!.readAsBytes();

      Logger.api('POST', '/storage/avatars/$userId');

      await Supabase.instance.client.storage
          .from('avatars')
          .uploadBinary(fileName, bytes);

      final publicUrl = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(fileName);

      Logger.success('Avatar uploaded');
      return publicUrl;
    } catch (e, st) {
      Logger.error('Avatar upload failed', error: e, stackTrace: st);
    }
    return null;
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final avatarUrl = await _uploadAvatar();

    if (!mounted) return;

    context.read<auth.AuthBloc>().add(auth.UpdateProfileEvent(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          avatarUrl: avatarUrl,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocListener<auth.AuthBloc, auth.AuthState>(
        listener: (context, state) {
          if (state is auth.AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is auth.Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully!')),
            );
            Navigator.of(context).pop();
          }
          setState(() => _isLoading = false);
        },
        child: !_isInitialized
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(MetaSpacing.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickAvatar,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: MetaColors.surfaceSoft,
                              backgroundImage: _selectedAvatar != null
                                  ? FileImage(_selectedAvatar!)
                                  : _currentAvatarUrl != null
                                      ? NetworkImage(_currentAvatarUrl!)
                                      : null,
                              child: _selectedAvatar == null &&
                                      _currentAvatarUrl == null
                                  ? Icon(Icons.person,
                                      size: 60, color: MetaColors.steel)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: MetaColors.inkButton,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: MetaColors.canvas, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: MetaSpacing.xs),
                      Text(
                        'Tap to change photo',
                        style: MetaTypography.caption.copyWith(
                            color: MetaColors.steel),
                      ),
                      const SizedBox(height: MetaSpacing.xxl),
                      MetaTextInput(
                        controller: _nameController,
                        labelText: 'Name',
                        prefixIcon: const Icon(Icons.person_outline),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: MetaSpacing.base),
                      MetaTextInput(
                        controller: _phoneController,
                        labelText: 'Phone (optional)',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: MetaSpacing.xxl),
                      MetaPrimaryButton(
                        label: 'Save Changes',
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
