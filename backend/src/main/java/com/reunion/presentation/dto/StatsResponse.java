package com.reunion.presentation.dto;

import java.util.Map;
import java.util.stream.Collectors;

import com.reunion.application.dto.StatsDTO;

public record StatsResponse(long total, Map<String, Long> perBatch) {

    public static StatsResponse from(StatsDTO dto) {
        Map<String, Long> flat = dto.perBatch().entrySet().stream()
            .collect(Collectors.toMap(e -> e.getKey().name(), Map.Entry::getValue));
        return new StatsResponse(dto.total(), flat);
    }
}
