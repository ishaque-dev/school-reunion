import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Renders a profile photo from either a `data:` URL or a regular network URL,
/// falling back to a builder if loading fails or the source is empty.
class ProfileImage extends StatelessWidget {
  final String? source;
  final Widget Function(BuildContext context) fallback;
  final BoxFit fit;

  const ProfileImage({
    super.key,
    required this.source,
    required this.fallback,
    this.fit = BoxFit.cover,
  });

  bool get _isDataUrl => source != null && source!.startsWith('data:');
  bool get _isUsable => source != null && source!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!_isUsable) return fallback(context);

    if (_isDataUrl) {
      try {
        final idx = source!.indexOf(',');
        final payload = idx >= 0 ? source!.substring(idx + 1) : source!;
        final bytes = base64Decode(payload);
        return Image.memory(
          Uint8List.fromList(bytes),
          fit: fit,
          gaplessPlayback: true,
          errorBuilder: (ctx, _, __) => fallback(ctx),
        );
      } catch (_) {
        return fallback(context);
      }
    }

    return Image.network(
      source!,
      fit: fit,
      gaplessPlayback: true,
      errorBuilder: (ctx, _, __) => fallback(ctx),
    );
  }
}
