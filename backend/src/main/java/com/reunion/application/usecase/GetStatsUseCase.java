package com.reunion.application.usecase;

import com.reunion.application.dto.StatsDTO;
import com.reunion.domain.model.Batch;
import com.reunion.domain.repository.AlumniRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.EnumMap;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class GetStatsUseCase {

    private final AlumniRepository repository;

    public StatsDTO execute() {
        Map<Batch, Long> perBatch = new EnumMap<>(Batch.class);
        for (Batch b : Batch.values()) {
            perBatch.put(b, repository.countByBatch(b));
        }
        return new StatsDTO(repository.count(), perBatch);
    }
}
