package com.reunion.application.usecase;

import com.reunion.domain.exception.AlumniNotFoundException;
import com.reunion.domain.model.Alumni;
import com.reunion.domain.repository.AlumniRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class UpdateAlumniUseCase {

    private final AlumniRepository repository;

    public Alumni execute(Long id, Alumni patch) {
        Alumni existing = repository.findById(id)
            .orElseThrow(() -> new AlumniNotFoundException(id));

        Alumni updated = existing.toBuilder()
            .name(patch.getName())
            .batch(patch.getBatch())
            .phone(patch.getPhone().orElse(null))
            .occupation(patch.getOccupation().orElse(null))
            .company(patch.getCompany().orElse(null))
            .address(patch.getAddress().orElse(null))
            .city(patch.getCity().orElse(null))
            .state(patch.getState().orElse(null))
            .country(patch.getCountry().orElse(null))
            .bio(patch.getBio().orElse(null))
            .linkedinUrl(patch.getLinkedinUrl().orElse(null))
            .profilePhotoUrl(patch.getProfilePhotoUrl().orElse(null))
            .graduationYear(patch.getGraduationYear().orElse(null))
            .build();

        return repository.save(updated);
    }
}
