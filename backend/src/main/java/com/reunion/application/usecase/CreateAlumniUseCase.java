package com.reunion.application.usecase;

import org.springframework.stereotype.Component;

import com.reunion.domain.exception.EmailAlreadyExistsException;
import com.reunion.domain.model.Alumni;
import com.reunion.domain.repository.AlumniRepository;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class CreateAlumniUseCase {

    private final AlumniRepository repository;

    public Alumni execute(Alumni alumni) {
        if (repository.existsByEmail(alumni.getEmail())) {
            throw new EmailAlreadyExistsException(alumni.getEmail());
        }
        return repository.save(alumni);
    }
}
