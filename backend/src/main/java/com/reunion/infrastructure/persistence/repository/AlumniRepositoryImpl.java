package com.reunion.infrastructure.persistence.repository;

import com.reunion.domain.model.Alumni;
import com.reunion.domain.model.Batch;
import com.reunion.domain.repository.AlumniRepository;
import com.reunion.infrastructure.persistence.entity.AlumniEntity;
import com.reunion.infrastructure.persistence.mapper.AlumniEntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Adapter that implements the domain repository contract using Spring Data JPA.
 */
@Repository
@RequiredArgsConstructor
public class AlumniRepositoryImpl implements AlumniRepository {

    private final JpaAlumniRepository jpa;
    private final AlumniEntityMapper mapper;

    @Override
    public List<Alumni> findAll() {
        return jpa.findAll().stream().map(mapper::toDomain).toList();
    }

    @Override
    public Optional<Alumni> findById(Long id) {
        return jpa.findById(id).map(mapper::toDomain);
    }

    @Override
    public List<Alumni> search(Optional<String> query, Optional<Batch> batch) {
        return jpa.search(query.orElse(""), batch.orElse(null))
            .stream()
            .map(mapper::toDomain)
            .toList();
    }

    @Override
    public Alumni save(Alumni alumni) {
        AlumniEntity entity = mapper.toEntity(alumni);
        AlumniEntity saved = jpa.save(entity);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(Long id) {
        jpa.deleteById(id);
    }

    @Override
    public boolean existsByEmail(String email) {
        return jpa.existsByEmail(email);
    }

    @Override
    public long countByBatch(Batch batch) {
        return jpa.countByBatch(batch);
    }

    @Override
    public long count() {
        return jpa.count();
    }
}
