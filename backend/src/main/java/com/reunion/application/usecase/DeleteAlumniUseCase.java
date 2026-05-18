package com.reunion.application.usecase;

import org.springframework.stereotype.Component;

import com.reunion.domain.exception.AlumniNotFoundException;
import com.reunion.domain.repository.AlumniRepository;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class DeleteAlumniUseCase {

    private final AlumniRepository repository;

    public void execute(Long id) {
        if (repository.findById(id).isEmpty()) {
            throw new AlumniNotFoundException(id);
        }
        repository.deleteById(id);
    }
}
