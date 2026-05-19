package com.reunion.infrastructure.persistence.entity;

import java.time.LocalDateTime;

import com.reunion.domain.model.Batch;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "alumni")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AlumniEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Batch batch;

    @Column(unique = true, nullable = false)
    private String email;

    private String phone;
    private String occupation;
    private String company;

    @Column(length = 500)
    private String address;

    private String city;
    private String state;
    private String country;

    @Column(length = 1000)
    private String bio;

    private String linkedinUrl;

    // Holds either a regular URL or a base64 data URL of an uploaded image.
    // TEXT column type fits both H2 and PostgreSQL with no fixed length cap.
    @Column(columnDefinition = "TEXT")
    private String profilePhotoUrl;

    private Integer graduationYear;

    @Column(updatable = false)
    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
