package com.reunion.presentation.dto;

import com.reunion.domain.model.Alumni;
import com.reunion.domain.model.Batch;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record AlumniRequest(
    @NotBlank(message = "Name is required") String name,
    @NotNull(message = "Batch is required") Batch batch,
    @NotBlank(message = "Email is required") @Email(message = "Invalid email") String email,
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
    Integer graduationYear
) {
    public Alumni toDomain() {
        return Alumni.builder()
            .name(name)
            .batch(batch)
            .email(email)
            .phone(phone)
            .occupation(occupation)
            .company(company)
            .address(address)
            .city(city)
            .state(state)
            .country(country)
            .bio(bio)
            .linkedinUrl(linkedinUrl)
            .profilePhotoUrl(profilePhotoUrl)
            .graduationYear(graduationYear)
            .build();
    }
}
