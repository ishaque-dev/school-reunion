package com.reunion.domain.model;

import java.util.Arrays;
import java.util.Optional;

public enum Batch {
    SCIENCE("Science"),
    COMMERCE_A("Commerce A"),
    COMMERCE_B("Commerce B"),
    COMMERCE_C("Commerce C");

    private final String displayName;

    Batch(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static Optional<Batch> fromString(String value) {
        if (value == null || value.isBlank()) return Optional.empty();
        return Arrays.stream(values())
            .filter(b -> b.name().equalsIgnoreCase(value))
            .findFirst();
    }
}
