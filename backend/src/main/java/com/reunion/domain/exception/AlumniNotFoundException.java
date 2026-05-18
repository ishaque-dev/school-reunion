package com.reunion.domain.exception;

public class AlumniNotFoundException extends RuntimeException {
    public AlumniNotFoundException(Long id) {
        super("Alumni not found with id: " + id);
    }
}
