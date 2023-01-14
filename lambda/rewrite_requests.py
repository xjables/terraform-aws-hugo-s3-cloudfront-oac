import os

index_document = os.getenv["INDEX_DOCUMENT"]

def handler(event):
    request = event["Records"][0]["cf"]["request"]
    uri = request["uri"]
    if uri.endswith("/"):
        request["uri"] += f"{index_document}"
    elif not "." in uri:
        request["uri"] += f"/{index_document}"
    
    return request