package com.toy.bidservice.controller;

import com.toy.bidservice.repository.BidRecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/metrics")
public class BidMetricsController {

    @Autowired
    private BidRecordRepository bidRecordRepository;

    @GetMapping
    public List<Map<String, Object>> getBiddingMetrics() {
        return bidRecordRepository.compileBiddingMetrics();
    }
}
