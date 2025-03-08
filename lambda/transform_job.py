import json

def lambda_handler(event, context):
    output_records = []
    for record in event['records']:
        # Decode the incoming data
        raw_data = json.loads(record['data'])

        # Perform transformation (example: add a timestamp)
        transformed_data = {
            "message": raw_data.get("message", ""),
            "timestamp": raw_data.get("timestamp", "N/A"),
            "processed": True
        }

        # Encode transformed data back to base64
        transformed_payload = json.dumps(transformed_data).encode('utf-8')

        output_records.append({
            'recordId': record['recordId'],
            'result': 'Ok',
            'data': transformed_payload
        })

    return {'records': output_records}
