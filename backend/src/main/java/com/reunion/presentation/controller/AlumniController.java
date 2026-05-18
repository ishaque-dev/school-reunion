package com.reunion.presentation.controller;

import com.reunion.application.usecase.CreateAlumniUseCase;
import com.reunion.application.usecase.DeleteAlumniUseCase;
import com.reunion.application.usecase.GetAlumniByIdUseCase;
import com.reunion.application.usecase.GetAlumniListUseCase;
import com.reunion.application.usecase.GetStatsUseCase;
import com.reunion.application.usecase.UpdateAlumniUseCase;
import com.reunion.presentation.dto.AlumniRequest;
import com.reunion.presentation.dto.AlumniResponse;
import com.reunion.presentation.dto.StatsResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/alumni")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class AlumniController {

    private final GetAlumniListUseCase listUseCase;
    private final GetAlumniByIdUseCase getByIdUseCase;
    private final CreateAlumniUseCase createUseCase;
    private final UpdateAlumniUseCase updateUseCase;
    private final DeleteAlumniUseCase deleteUseCase;
    private final GetStatsUseCase statsUseCase;

    @GetMapping
    public List<AlumniResponse> list(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String batch) {
        return listUseCase.execute(Optional.ofNullable(search), Optional.ofNullable(batch))
            .stream().map(AlumniResponse::from).toList();
    }

    @GetMapping("/{id}")
    public AlumniResponse getById(@PathVariable Long id) {
        return AlumniResponse.from(getByIdUseCase.execute(id));
    }

    @PostMapping
    public ResponseEntity<AlumniResponse> create(@Valid @RequestBody AlumniRequest request) {
        var created = createUseCase.execute(request.toDomain());
        return ResponseEntity.status(HttpStatus.CREATED).body(AlumniResponse.from(created));
    }

    @PutMapping("/{id}")
    public AlumniResponse update(@PathVariable Long id, @Valid @RequestBody AlumniRequest request) {
        return AlumniResponse.from(updateUseCase.execute(id, request.toDomain()));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        deleteUseCase.execute(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/stats")
    public StatsResponse stats() {
        return StatsResponse.from(statsUseCase.execute());
    }
}
