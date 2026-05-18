package com.reunion.infrastructure.persistence.mapper;

import org.springframework.stereotype.Component;

import com.reunion.domain.model.Alumni;
import com.reunion.infrastructure.persistence.entity.AlumniEntity;

@Component
public class AlumniEntityMapper {

    public Alumni toDomain(AlumniEntity e) {
        return Alumni.builder()
            .id(e.getId())
            .name(e.getName())
            .batch(e.getBatch())
            .email(e.getEmail())
            .phone(e.getPhone())
            .occupation(e.getOccupation())
            .company(e.getCompany())
            .address(e.getAddress())
            .city(e.getCity())
            .state(e.getState())
            .country(e.getCountry())
            .bio(e.getBio())
            .linkedinUrl(e.getLinkedinUrl())
            .profilePhotoUrl(e.getProfilePhotoUrl())
            .graduationYear(e.getGraduationYear())
            .createdAt(e.getCreatedAt())
            .updatedAt(e.getUpdatedAt())
            .build();
    }

    public AlumniEntity toEntity(Alumni a) {
        return AlumniEntity.builder()
            .id(a.getId().orElse(null))
            .name(a.getName())
            .batch(a.getBatch())
            .email(a.getEmail())
            .phone(a.getPhone().orElse(null))
            .occupation(a.getOccupation().orElse(null))
            .company(a.getCompany().orElse(null))
            .address(a.getAddress().orElse(null))
            .city(a.getCity().orElse(null))
            .state(a.getState().orElse(null))
            .country(a.getCountry().orElse(null))
            .bio(a.getBio().orElse(null))
            .linkedinUrl(a.getLinkedinUrl().orElse(null))
            .profilePhotoUrl(a.getProfilePhotoUrl().orElse(null))
            .graduationYear(a.getGraduationYear().orElse(null))
            .build();
    }
}
