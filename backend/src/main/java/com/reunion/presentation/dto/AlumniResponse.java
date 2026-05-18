package com.reunion.presentation.dto;

import java.time.LocalDateTime;

import com.reunion.domain.model.Alumni;
import com.reunion.domain.model.Batch;

public record AlumniResponse(
    Long id,
    String name,
    Batch batch,
    String email,
    String phone,
    String occupation,
    String company,
    String address,
    String city,
    String state,
    String country,
    String bio,
    String linkedinUrl,
    String profilePhotoUrl,
    Integer graduationYear,
    LocalDateTime createdAt,
    LocalDateTime updatedAt
) {
    public static AlumniResponse from(Alumni a) {
        return new AlumniResponse(
            a.getId().orElse(null),
            a.getName(),
            a.getBatch(),
            a.getEmail(),
            a.getPhone().orElse(null),
            a.getOccupation().orElse(null),
            a.getCompany().orElse(null),
            a.getAddress().orElse(null),
            a.getCity().orElse(null),
            a.getState().orElse(null),
            a.getCountry().orElse(null),
            a.getBio().orElse(null),
            a.getLinkedinUrl().orElse(null),
            a.getProfilePhotoUrl().orElse(null),
            a.getGraduationYear().orElse(null),
            a.getCreatedAt().orElse(null),
            a.getUpdatedAt().orElse(null)
        );
    }
}
