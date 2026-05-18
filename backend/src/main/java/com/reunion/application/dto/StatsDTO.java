package com.reunion.application.dto;

import java.util.Map;

import com.reunion.domain.model.Batch;

public record StatsDTO(long total, Map<Batch, Long> perBatch) {}
