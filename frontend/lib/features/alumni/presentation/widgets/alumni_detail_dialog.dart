import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/alumni.dart';
import '../../domain/entities/batch.dart';
import 'profile_image.dart';

class AlumniDetailDialog extends StatelessWidget {
  final Alumni alumni;
  const AlumniDetailDialog({super.key, required this.alumni});

  static Future<void> show(BuildContext context, Alumni alumni) {
    return showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => AlumniDetailDialog(alumni: alumni),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dialogWidth = width < 600 ? width * 0.92 : 560.0;
    final batch = alumni.batch;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: dialogWidth,
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(gradient: batch.gradient),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -50),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 5),
                    gradient: batch.gradient,
                    boxShadow: [
                      BoxShadow(
                        color: batch.color.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: ProfileImage(
                      source: alumni.profilePhotoUrl,
                      fallback: (_) => _initialsAvatar(),
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -30),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      Text(
                        alumni.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: batch.lightColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: batch.color.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(batch.icon, size: 14, color: batch.color),
                            const SizedBox(width: 6),
                            Text(
                              batch.displayName,
                              style: TextStyle(
                                color: batch.color,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            if (alumni.graduationYear != null) ...[
                              const SizedBox(width: 6),
                              Text(
                                '• ${alumni.graduationYear}',
                                style: TextStyle(
                                  color: batch.color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (alumni.occupation != null && alumni.occupation!.isNotEmpty)
                        Text(
                          alumni.headline,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      if (alumni.bio != null && alumni.bio!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '"${alumni.bio}"',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      const SizedBox(height: 22),
                      _InfoTile(icon: Icons.email_outlined, label: 'Email', value: alumni.email),
                      if (alumni.phone != null && alumni.phone!.isNotEmpty)
                        _InfoTile(icon: Icons.phone_outlined, label: 'Phone', value: alumni.phone!),
                      if (alumni.address != null && alumni.address!.isNotEmpty)
                        _InfoTile(icon: Icons.home_outlined, label: 'Address', value: alumni.address!),
                      if (alumni.location.isNotEmpty)
                        _InfoTile(
                          icon: Icons.location_on_outlined,
                          label: 'Location',
                          value: [alumni.location, alumni.country]
                              .where((s) => s != null && s.isNotEmpty)
                              .join(', '),
                        ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          if (alumni.phone != null && alumni.phone!.isNotEmpty)
                            Expanded(
                              child: _BigBtn(
                                icon: Icons.phone_rounded,
                                label: 'Call',
                                color: AppColors.success,
                                onTap: () => _launch('tel:${alumni.phone}'),
                              ),
                            ),
                          if (alumni.phone != null && alumni.phone!.isNotEmpty)
                            const SizedBox(width: 10),
                          Expanded(
                            child: _BigBtn(
                              icon: Icons.mail_rounded,
                              label: 'Email',
                              color: AppColors.primary,
                              onTap: () => _launch('mailto:${alumni.email}'),
                            ),
                          ),
                          if (alumni.linkedinUrl != null &&
                              alumni.linkedinUrl!.isNotEmpty) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: _BigBtn(
                                icon: Icons.work_outline_rounded,
                                label: 'LinkedIn',
                                color: const Color(0xFF0A66C2),
                                onTap: () => _launch(alumni.linkedinUrl!),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _initialsAvatar() => Center(
        child: Text(
          alumni.initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BigBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BigBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
