package com.reunion.application.usecase;

import com.reunion.domain.model.Alumni;
import com.reunion.domain.model.Batch;
import com.reunion.domain.repository.AlumniRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

@Component
@RequiredArgsConstructor
public class GetAlumniListUseCase {

    private final AlumniRepository repository;

    public List<Alumni> execute(Optional<String> search, Optional<String> batch) {
        boolean noSearch = search.map(String::isBlank).orElse(true);
        Optional<Batch> batchEnum = batch.flatMap(Batch::fromString);

        if (noSearch && batchEnum.isEmpty()) {
            return repository.findAll();
        }
        return repository.search(search.filter(s -> !s.isBlank()), batchEnum);
    }
}
