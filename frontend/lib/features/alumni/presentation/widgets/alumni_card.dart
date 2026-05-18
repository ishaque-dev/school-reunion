import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/alumni.dart';
import '../../domain/entities/batch.dart';
import 'profile_image.dart';

class AlumniCard extends StatefulWidget {
  final Alumni alumni;
  final VoidCallback onTap;

  const AlumniCard({super.key, required this.alumni, required this.onTap});

  @override
  State<AlumniCard> createState() => _AlumniCardState();
}

class _AlumniCardState extends State<AlumniCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final batch = widget.alumni.batch;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _hovered ? -6.0 : 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? batch.color.withOpacity(0.25)
                  : Colors.black.withOpacity(0.06),
              blurRadius: _hovered ? 24 : 12,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: _hovered ? batch.color.withOpacity(0.3) : AppColors.border,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: batch.gradient,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _Avatar(alumni: widget.alumni),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.alumni.name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                _BatchChip(batch: batch),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (widget.alumni.occupation != null &&
                          widget.alumni.occupation!.isNotEmpty)
                        _InfoRow(
                          icon: Icons.work_outline,
                          text: widget.alumni.headline,
                          color: AppColors.textPrimary,
                        ),
                      if (widget.alumni.location.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _InfoRow(
                          icon: Icons.location_on_outlined,
                          text: widget.alumni.location,
                          color: AppColors.textSecondary,
                        ),
                      ],
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          if (widget.alumni.phone != null &&
                              widget.alumni.phone!.isNotEmpty)
                            Expanded(
                              child: _ActionBtn(
                                icon: Icons.phone_rounded,
                                label: 'Call',
                                color: AppColors.success,
                                onTap: () => _launch('tel:${widget.alumni.phone}'),
                              ),
                            ),
                          if (widget.alumni.phone != null &&
                              widget.alumni.phone!.isNotEmpty)
                            const SizedBox(width: 8),
                          Expanded(
                            child: _ActionBtn(
                              icon: Icons.mail_outline_rounded,
                              label: 'Email',
                              color: AppColors.primary,
                              onTap: () => _launch('mailto:${widget.alumni.email}'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _ArrowBtn(color: batch.color, onTap: widget.onTap),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _Avatar extends StatelessWidget {
  final Alumni alumni;
  const _Avatar({required this.alumni});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: alumni.batch.gradient,
        boxShadow: [
          BoxShadow(
            color: alumni.batch.color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: ProfileImage(
          source: alumni.profilePhotoUrl,
          fallback: (_) => _initials(),
        ),
      ),
    );
  }

  Widget _initials() => Center(
        child: Text(
          alumni.initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

class _BatchChip extends StatelessWidget {
  final Batch batch;
  const _BatchChip({required this.batch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: batch.lightColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: batch.color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(batch.icon, size: 12, color: batch.color),
          const SizedBox(width: 4),
          Text(
            batch.displayName,
            style: TextStyle(
              color: batch.color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _InfoRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color.withOpacity(0.7)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: color, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: color,
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

class _ArrowBtn extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const _ArrowBtn({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
