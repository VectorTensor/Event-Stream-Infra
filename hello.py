import json
import logging
import base64

logging.basicConfig(level=logging.INFO)  # Set logging level
logger = logging.getLogger(__name__)  # Create a logger
def lambda_handler(event, context):
    output_records = []
    for record in event['records']:
        # Decode the incoming data
        # logger.error(f"Prayash record: {record}")
        decoded_bytes = base64.b64decode(record['data'])
        decoded_str = decoded_bytes.decode("utf-8")
        raw_data = json.loads(decoded_str)

        # Perform transformation (example: add a timestamp)
        transformed_data = {
            "message": raw_data.get("message", ""),
            "timestamp": raw_data.get("timestamp", "N/A"),
            "processed": True
        }

        # Encode transformed data back to base64
        transformed_payload = json.dumps(transformed_data).encode('utf-8')
        encoded_data = base64.b64encode(transformed_payload)

        output_records.append({
            'recordId': record['recordId'],
            'result': 'Ok',
            'data': encoded_data
        })

    return {'records': output_records}
