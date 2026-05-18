package com.reunion.application.usecase;

import com.reunion.domain.exception.AlumniNotFoundException;
import com.reunion.domain.model.Alumni;
import com.reunion.domain.repository.AlumniRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class GetAlumniByIdUseCase {

    private final AlumniRepository repository;

    public Alumni execute(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new AlumniNotFoundException(id));
    }
}
