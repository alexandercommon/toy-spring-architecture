package com.toy.bidservice.consumer;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;
import java.util.Map;

@Service
public class OrderConsumer {

    @KafkaListener(topics = "toy-orders", groupId = "toy-bid-service-group")
    public void handleOrderEvent(Map<String, Object> orderPayload) {
        System.out.println("====== KAFKA PIPELINE CONSUMER EVENT ======");
        System.out.println("Successfully captured streamed order event: " + orderPayload);
        // Phase 3 will ingest this data structure downstream into MongoDB Atlas
    }
}
