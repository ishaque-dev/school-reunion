package com.reunion.domain.model;

import java.time.LocalDateTime;
import java.util.Optional;

import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.NonNull;
import lombok.ToString;

/**
 * Pure domain entity. No framework, no JPA.
 * Lombok generates the builder, equals/hashCode, and toString.
 * Required fields use @NonNull so the generated constructor enforces it.
 * Optional getters are written manually so absence is explicit at the type level.
 */
@Builder(toBuilder = true)
@EqualsAndHashCode
@ToString
public class Alumni {

    private final Long id;
    @NonNull private final String name;
    @NonNull private final Batch batch;
    @NonNull private final String email;
    private final String phone;
    private final String occupation;
    private final String company;
    private final String address;
    private final String city;
    private final String state;
    private final String country;
    private final String bio;
    private final String linkedinUrl;
    private final String profilePhotoUrl;
    private final Integer graduationYear;
    private final LocalDateTime createdAt;
    private final LocalDateTime updatedAt;

    public Optional<Long> getId() { return Optional.ofNullable(id); }
    public String getName() { return name; }
    public Batch getBatch() { return batch; }
    public String getEmail() { return email; }
    public Optional<String> getPhone() { return Optional.ofNullable(phone); }
    public Optional<String> getOccupation() { return Optional.ofNullable(occupation); }
    public Optional<String> getCompany() { return Optional.ofNullable(company); }
    public Optional<String> getAddress() { return Optional.ofNullable(address); }
    public Optional<String> getCity() { return Optional.ofNullable(city); }
    public Optional<String> getState() { return Optional.ofNullable(state); }
    public Optional<String> getCountry() { return Optional.ofNullable(country); }
    public Optional<String> getBio() { return Optional.ofNullable(bio); }
    public Optional<String> getLinkedinUrl() { return Optional.ofNullable(linkedinUrl); }
    public Optional<String> getProfilePhotoUrl() { return Optional.ofNullable(profilePhotoUrl); }
    public Optional<Integer> getGraduationYear() { return Optional.ofNullable(graduationYear); }
    public Optional<LocalDateTime> getCreatedAt() { return Optional.ofNullable(createdAt); }
    public Optional<LocalDateTime> getUpdatedAt() { return Optional.ofNullable(updatedAt); }
}
