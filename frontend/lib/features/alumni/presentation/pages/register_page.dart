import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/alumni.dart';
import '../../domain/entities/batch.dart';
import '../bloc/alumni_list_bloc.dart';
import '../bloc/register_bloc.dart';
import '../bloc/stats_cubit.dart';
import '../widgets/profile_photo_picker.dart';
import 'directory_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _occupation = TextEditingController();
  final _company = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _country = TextEditingController(text: 'India');
  final _bio = TextEditingController();
  final _linkedin = TextEditingController();
  final _gradYear = TextEditingController();

  Batch? _selectedBatch;
  String? _profilePhotoDataUrl;

  @override
  void dispose() {
    for (final c in [
      _name, _email, _phone, _occupation, _company, _address,
      _city, _state, _country, _bio, _linkedin, _gradYear,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_selectedBatch == null) {
      _toast('Please select your batch', error: true);
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final alumni = Alumni(
      name: _name.text.trim(),
      batch: _selectedBatch!,
      email: _email.text.trim(),
      phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      occupation: _occupation.text.trim().isEmpty ? null : _occupation.text.trim(),
      company: _company.text.trim().isEmpty ? null : _company.text.trim(),
      address: _address.text.trim().isEmpty ? null : _address.text.trim(),
      city: _city.text.trim().isEmpty ? null : _city.text.trim(),
      state: _state.text.trim().isEmpty ? null : _state.text.trim(),
      country: _country.text.trim().isEmpty ? null : _country.text.trim(),
      bio: _bio.text.trim().isEmpty ? null : _bio.text.trim(),
      linkedinUrl: _linkedin.text.trim().isEmpty ? null : _linkedin.text.trim(),
      profilePhotoUrl: _profilePhotoDataUrl,
      graduationYear: int.tryParse(_gradYear.text.trim()),
    );

    context.read<RegisterBloc>().add(RegisterSubmitted(alumni));
  }

  void _toast(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? AppColors.secondary : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE8F8E8),
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: AppColors.success, size: 50),
              ),
              const SizedBox(height: 20),
              const Text(
                'You\'re in! 🎉',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Welcome to the reunion. Your classmates can now find you.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<AlumniListBloc>().add(const AlumniListRefreshed());
                    context.read<StatsCubit>().load();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const DirectoryPage()),
                    );
                  },
                  child: const Text('Browse Alumni'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.success) {
          _showSuccessDialog();
        } else if (state.status == RegisterStatus.failure) {
          _toast(state.errorMessage ?? 'Registration failed', error: true);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 60, vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton.filled(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Join the Reunion',
                                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'Fill in your details so your classmates can find you',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _SectionTitle(title: 'Choose Your Batch', icon: Icons.class_rounded),
                            const SizedBox(height: 14),
                            _BatchSelector(
                              selected: _selectedBatch,
                              onSelect: (b) => setState(() => _selectedBatch = b),
                            ),
                            const SizedBox(height: 28),
                            const _SectionTitle(title: 'Personal Info', icon: Icons.person_rounded),
                            const SizedBox(height: 14),
                            _Field(
                              label: 'Full Name *',
                              controller: _name,
                              icon: Icons.badge_outlined,
                              validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
                            ),
                            const SizedBox(height: 14),
                            _DoubleField(
                              children: [
                                _Field(
                                  label: 'Email *',
                                  controller: _email,
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Email is required';
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                                      return 'Invalid email';
                                    }
                                    return null;
                                  },
                                ),
                                _Field(
                                  label: 'Phone',
                                  controller: _phone,
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _Field(
                              label: 'Graduation Year',
                              controller: _gradYear,
                              icon: Icons.school_outlined,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 22),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: ProfilePhotoPicker(
                                dataUrl: _profilePhotoDataUrl,
                                onImageSelected: (url) =>
                                    setState(() => _profilePhotoDataUrl = url),
                              ),
                            ),
                            const SizedBox(height: 28),
                            const _SectionTitle(title: 'Professional', icon: Icons.work_rounded),
                            const SizedBox(height: 14),
                            _DoubleField(
                              children: [
                                _Field(label: 'Occupation', controller: _occupation, icon: Icons.work_outline),
                                _Field(label: 'Company', controller: _company, icon: Icons.business_outlined),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _Field(label: 'LinkedIn URL', controller: _linkedin, icon: Icons.link_rounded),
                            const SizedBox(height: 28),
                            const _SectionTitle(title: 'Where You Are', icon: Icons.location_on_rounded),
                            const SizedBox(height: 14),
                            _Field(label: 'Address', controller: _address, icon: Icons.home_outlined),
                            const SizedBox(height: 14),
                            _DoubleField(
                              children: [
                                _Field(label: 'City', controller: _city, icon: Icons.location_city_outlined),
                                _Field(label: 'State', controller: _state, icon: Icons.map_outlined),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _Field(label: 'Country', controller: _country, icon: Icons.public_outlined),
                            const SizedBox(height: 28),
                            const _SectionTitle(title: 'About You', icon: Icons.auto_awesome_rounded),
                            const SizedBox(height: 14),
                            _Field(
                              label: 'Tell your classmates what you\'ve been up to',
                              controller: _bio,
                              icon: Icons.format_quote_rounded,
                              maxLines: 4,
                            ),
                            const SizedBox(height: 32),
                            BlocBuilder<RegisterBloc, RegisterState>(
                              builder: (context, state) {
                                final submitting = state.status == RegisterStatus.submitting;
                                return SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: submitting ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                    child: submitting
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Complete Registration',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                              SizedBox(width: 8),
                                              Icon(Icons.arrow_forward_rounded),
                                            ],
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;

  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}

class _DoubleField extends StatelessWidget {
  final List<Widget> children;
  const _DoubleField({required this.children});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    if (isMobile) {
      return Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) const SizedBox(height: 14),
          ],
        ],
      );
    }
    return Row(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i < children.length - 1) const SizedBox(width: 14),
        ],
      ],
    );
  }
}

class _BatchSelector extends StatelessWidget {
  final Batch? selected;
  final ValueChanged<Batch> onSelect;

  const _BatchSelector({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth >= 700 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: cols,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: cols == 4 ? 1.2 : 1.5,
          children: Batch.values.map((b) {
            final sel = selected == b;
            return Material(
              color: sel ? b.color : Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () => onSelect(b),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: sel ? b.color : AppColors.border,
                      width: sel ? 0 : 1,
                    ),
                    boxShadow: sel
                        ? [BoxShadow(color: b.color.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(b.icon, color: sel ? Colors.white : b.color, size: 26),
                      const SizedBox(height: 8),
                      Text(
                        b.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: sel ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
