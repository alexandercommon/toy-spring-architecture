package com.toy.bidservice.consumer;

import com.toy.bidservice.model.BidRecord;
import com.toy.bidservice.repository.BidRecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;
import java.util.Map;
import java.util.UUID;

@Service
public class OrderConsumer {

    @Autowired
    private BidRecordRepository bidRecordRepository;

    @KafkaListener(topics = "toy-orders", groupId = "toy-bid-service-group")
    public void handleOrderEvent(Map<String, Object> orderPayload) {
        System.out.println("====== KAFKA PIPELINE CONSUMER EVENT ======");
        System.out.println("Successfully captured streamed order event: " + orderPayload);
        
        // Associate with transmitted order identifier or fallback to dynamic UUID
        String orderId = orderPayload.containsKey("orderId") ? 
                String.valueOf(orderPayload.get("orderId")) : 
                UUID.randomUUID().toString();

        // Phase 3: Ingest unstructured document downstream into MongoDB Atlas
        BidRecord record = new BidRecord(orderId, orderPayload);
        bidRecordRepository.save(record);
        
        System.out.println(">>> Stored unstructured document for Order ID: " + orderId);
        System.out.println(">>> Current Live Metrics: " + bidRecordRepository.compileBiddingMetrics());
    }
}
