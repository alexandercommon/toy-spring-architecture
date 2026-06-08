package com.toy.orderservice.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.Map;

@RestController
@RequestMapping("/orders")
public class OrderController {

    @PostMapping
    public ResponseEntity<?> createOrder(@RequestBody Map<String, Object> orderPayload) {
        // Validation check to demonstrate RFC 9457 error standard compliance
        if (!orderPayload.containsKey("item") || orderPayload.get("item") == null) {
            ProblemDetail problemDetail = ProblemDetail.forStatusAndDetail(
                    HttpStatus.BAD_REQUEST, 
                    "Missing mandatory structural field: 'item'"
            );
            problemDetail.setTitle("Invalid Order Specification");
            problemDetail.setType(URI.create("https://toy-architecture.local/errors/missing-item"));
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(problemDetail);
        }

        String contextRole = SecurityContextHolder.getContext().getAuthentication().getAuthorities().toString();

        return ResponseEntity.ok(Map.of(
            "status", "ORDER_PROCESSED_SIMULATION",
            "receivedItem", orderPayload.get("item"),
            "evaluatedRoleContext", contextRole
        ));
    }
}
