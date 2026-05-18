import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';

/// Lets the user pick an image, downscales it to <= [maxSize] px on the longest
/// edge, re-encodes as JPEG at quality 80, and emits a `data:` URL via
/// [onImageSelected]. Pass `null` to clear.
class ProfilePhotoPicker extends StatefulWidget {
  final String? dataUrl;
  final ValueChanged<String?> onImageSelected;
  final int maxSize;
  final int jpegQuality;

  const ProfilePhotoPicker({
    super.key,
    required this.dataUrl,
    required this.onImageSelected,
    this.maxSize = 512,
    this.jpegQuality = 80,
  });

  @override
  State<ProfilePhotoPicker> createState() => _ProfilePhotoPickerState();
}

class _ProfilePhotoPickerState extends State<ProfilePhotoPicker> {
  final ImagePicker _picker = ImagePicker();
  bool _processing = false;
  String? _error;

  Future<void> _pick() async {
    setState(() {
      _error = null;
      _processing = true;
    });
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 95, // we'll re-encode anyway; this just hints to the OS
      );
      if (file == null) {
        if (mounted) setState(() => _processing = false);
        return;
      }
      final bytes = await file.readAsBytes();
      final dataUrl = await _compressToDataUrl(bytes);
      if (!mounted) return;
      widget.onImageSelected(dataUrl);
      setState(() => _processing = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _processing = false;
        _error = 'Could not load image. Try a smaller one.';
      });
    }
  }

  Future<String> _compressToDataUrl(Uint8List bytes) async {
    // Decode + resize off the UI thread on non-web; on web fall back to sync.
    final processed = kIsWeb
        ? _processBytes(bytes, widget.maxSize, widget.jpegQuality)
        : await compute<_PickArgs, Uint8List>(
            _processInIsolate,
            _PickArgs(bytes, widget.maxSize, widget.jpegQuality),
          );
    return 'data:image/jpeg;base64,${base64Encode(processed)}';
  }

  void _clear() => widget.onImageSelected(null);

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.dataUrl != null && widget.dataUrl!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Avatar(dataUrl: widget.dataUrl, processing: _processing),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasImage ? 'Looking sharp!' : 'Add a profile photo',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasImage
                        ? 'Tap below to change or remove your photo.'
                        : 'Optional — helps classmates recognize you instantly.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _PickerBtn(
                        icon: Icons.upload_rounded,
                        label: hasImage ? 'Change' : 'Upload photo',
                        primary: !hasImage,
                        onTap: _processing ? null : _pick,
                      ),
                      if (hasImage)
                        _PickerBtn(
                          icon: Icons.delete_outline_rounded,
                          label: 'Remove',
                          primary: false,
                          danger: true,
                          onTap: _processing ? null : _clear,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: AppColors.secondary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: AppColors.secondary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? dataUrl;
  final bool processing;
  const _Avatar({required this.dataUrl, required this.processing});

  @override
  Widget build(BuildContext context) {
    final hasImage = dataUrl != null && dataUrl!.isNotEmpty;
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.heroGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: processing
            ? const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              )
            : hasImage
                ? ClipOval(
                    child: Image.memory(
                      _decodeDataUrl(dataUrl!),
                      fit: BoxFit.cover,
                      width: 78,
                      height: 78,
                    ),
                  )
                : const Icon(Icons.person_outline_rounded,
                    size: 38, color: AppColors.textSecondary),
      ),
    );
  }
}

class _PickerBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool primary;
  final bool danger;
  final VoidCallback? onTap;

  const _PickerBtn({
    required this.icon,
    required this.label,
    required this.primary,
    this.danger = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.secondary : AppColors.primary;
    final bg = primary ? color : color.withOpacity(0.08);
    final fg = primary ? Colors.white : color;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: fg,
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

Uint8List _decodeDataUrl(String dataUrl) {
  final idx = dataUrl.indexOf(',');
  final payload = idx >= 0 ? dataUrl.substring(idx + 1) : dataUrl;
  return base64Decode(payload);
}

// ---- image processing (shared by web sync path and isolate path) ----

class _PickArgs {
  final Uint8List bytes;
  final int maxSize;
  final int quality;
  const _PickArgs(this.bytes, this.maxSize, this.quality);
}

Uint8List _processInIsolate(_PickArgs args) =>
    _processBytes(args.bytes, args.maxSize, args.quality);

Uint8List _processBytes(Uint8List bytes, int maxSize, int quality) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    throw StateError('Unsupported image format');
  }
  final resized = (decoded.width > maxSize || decoded.height > maxSize)
      ? img.copyResize(
          decoded,
          width: decoded.width >= decoded.height ? maxSize : null,
          height: decoded.height > decoded.width ? maxSize : null,
          interpolation: img.Interpolation.linear,
        )
      : decoded;
  return Uint8List.fromList(img.encodeJpg(resized, quality: quality));
}
