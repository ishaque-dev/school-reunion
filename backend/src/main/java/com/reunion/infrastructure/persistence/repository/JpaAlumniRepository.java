package com.reunion.infrastructure.persistence.repository;

import com.reunion.domain.model.Batch;
import com.reunion.infrastructure.persistence.entity.AlumniEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface JpaAlumniRepository extends JpaRepository<AlumniEntity, Long> {

    @Query("SELECT a FROM AlumniEntity a WHERE " +
           "(:search IS NULL OR " +
           "LOWER(a.name) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(COALESCE(a.occupation, '')) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(COALESCE(a.city, '')) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(COALESCE(a.company, '')) LIKE LOWER(CONCAT('%', :search, '%'))) AND " +
           "(:batch IS NULL OR a.batch = :batch)")
    List<AlumniEntity> search(@Param("search") String search, @Param("batch") Batch batch);

    long countByBatch(Batch batch);

    boolean existsByEmail(String email);
}
