package com.toy.bidservice.repository;

import com.toy.bidservice.model.BidRecord;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Aggregation;
import java.util.List;
import java.util.Map;

public interface BidRecordRepository extends MongoRepository<BidRecord, String> {

    // Phase 3: Utilizing @Aggregation to compile real-time metrics
    @Aggregation(pipeline = {
        "{ '$group': { '_id': '$payload.item', 'totalBids': { '$sum': 1 } } }"
    })
    List<Map<String, Object>> compileBiddingMetrics();
}
