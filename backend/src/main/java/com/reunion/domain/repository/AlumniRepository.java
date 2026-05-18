package com.reunion.domain.repository;

import com.reunion.domain.model.Alumni;
import com.reunion.domain.model.Batch;

import java.util.List;
import java.util.Optional;

/**
 * Domain repository contract. Framework-agnostic.
 * Implemented in the infrastructure layer.
 */
public interface AlumniRepository {

    List<Alumni> findAll();

    Optional<Alumni> findById(Long id);

    List<Alumni> search(Optional<String> query, Optional<Batch> batch);

    Alumni save(Alumni alumni);

    void deleteById(Long id);

    boolean existsByEmail(String email);

    long countByBatch(Batch batch);

    long count();
}
