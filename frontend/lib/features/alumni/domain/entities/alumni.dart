import 'package:equatable/equatable.dart';
import 'batch.dart';

class Alumni extends Equatable {
  final int? id;
  final String name;
  final Batch batch;
  final String email;
  final String? phone;
  final String? occupation;
  final String? company;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? bio;
  final String? linkedinUrl;
  final String? profilePhotoUrl;
  final int? graduationYear;

  const Alumni({
    this.id,
    required this.name,
    required this.batch,
    required this.email,
    this.phone,
    this.occupation,
    this.company,
    this.address,
    this.city,
    this.state,
    this.country,
    this.bio,
    this.linkedinUrl,
    this.profilePhotoUrl,
    this.graduationYear,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String get location {
    final parts = <String>[];
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    return parts.join(', ');
  }

  String get headline {
    if (occupation == null || occupation!.isEmpty) return 'Alumni';
    if (company == null || company!.isEmpty) return occupation!;
    return '$occupation at $company';
  }

  @override
  List<Object?> get props => [
        id, name, batch, email, phone, occupation, company,
        address, city, state, country, bio, linkedinUrl,
        profilePhotoUrl, graduationYear,
      ];
}
