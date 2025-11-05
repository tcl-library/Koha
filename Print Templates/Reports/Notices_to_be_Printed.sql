SELECT borrowernumber, letter_code, content, message_transport_type, to_address, from_address, updated_on, status
FROM message_queue
WHERE updated_on 
BETWEEN <<Sent between|date>> AND <<and|date>> 
AND letter_code = 'TMODUE_FINAL'
AND message_transport_type = 'email'
ORDER BY from_address DESC