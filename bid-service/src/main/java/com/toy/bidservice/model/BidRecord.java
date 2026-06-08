package com.toy.bidservice.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Map;

@Document(collection = "bid_records")
public class BidRecord {
    
    @Id
    private String id;
    private String orderId;
    private Map<String, Object> payload;

    public BidRecord() {}

    public BidRecord(String orderId, Map<String, Object> payload) {
        this.orderId = orderId;
        this.payload = payload;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public Map<String, Object> getPayload() { return payload; }
    public void setPayload(Map<String, Object> payload) { this.payload = payload; }
}
