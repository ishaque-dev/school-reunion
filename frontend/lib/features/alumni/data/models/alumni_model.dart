import '../../domain/entities/alumni.dart';
import '../../domain/entities/batch.dart';

class AlumniModel extends Alumni {
  const AlumniModel({
    super.id,
    required super.name,
    required super.batch,
    required super.email,
    super.phone,
    super.occupation,
    super.company,
    super.address,
    super.city,
    super.state,
    super.country,
    super.bio,
    super.linkedinUrl,
    super.profilePhotoUrl,
    super.graduationYear,
  });

  factory AlumniModel.fromJson(Map<String, dynamic> json) {
    return AlumniModel(
      id: json['id'] as int?,
      name: (json['name'] as String?) ?? '',
      batch: BatchX.fromString(json['batch'] as String?) ?? Batch.SCIENCE,
      email: (json['email'] as String?) ?? '',
      phone: json['phone'] as String?,
      occupation: json['occupation'] as String?,
      company: json['company'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      bio: json['bio'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      graduationYear: json['graduationYear'] as int?,
    );
  }

  factory AlumniModel.fromEntity(Alumni a) => AlumniModel(
        id: a.id,
        name: a.name,
        batch: a.batch,
        email: a.email,
        phone: a.phone,
        occupation: a.occupation,
        company: a.company,
        address: a.address,
        city: a.city,
        state: a.state,
        country: a.country,
        bio: a.bio,
        linkedinUrl: a.linkedinUrl,
        profilePhotoUrl: a.profilePhotoUrl,
        graduationYear: a.graduationYear,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'batch': batch.apiValue,
        'email': email,
        if (phone != null && phone!.isNotEmpty) 'phone': phone,
        if (occupation != null && occupation!.isNotEmpty) 'occupation': occupation,
        if (company != null && company!.isNotEmpty) 'company': company,
        if (address != null && address!.isNotEmpty) 'address': address,
        if (city != null && city!.isNotEmpty) 'city': city,
        if (state != null && state!.isNotEmpty) 'state': state,
        if (country != null && country!.isNotEmpty) 'country': country,
        if (bio != null && bio!.isNotEmpty) 'bio': bio,
        if (linkedinUrl != null && linkedinUrl!.isNotEmpty) 'linkedinUrl': linkedinUrl,
        if (profilePhotoUrl != null && profilePhotoUrl!.isNotEmpty)
          'profilePhotoUrl': profilePhotoUrl,
        if (graduationYear != null) 'graduationYear': graduationYear,
      };
}
