from typing import Any, Dict, List, Optional, Tuple
import requests
import sys
from datetime import datetime
import os
import time

tenant_name = "insert your tenant name"
base_url = f"https://{tenant_name}-svc.fundapps.co/api/adapptr/v2/"

username = os.environ.get("ADAPPTR_USERNAME")
password = os.environ.get("ADAPPTR_PASSWORD")

def upload_file(file_path: str, snapshote_date: datetime.date) -> str:
    """
    Posts a position file for a specific date.
    
    Args:
        file_path (str): The path to the file to be posted.
        snapshot_date (datetime.date): The date that the position data relates to
        
    Returns:
        Task Id: The Adapptr id for the run (used to check status)
    """
    url = f"{base_url}task/positions"

    # All options available here: https://github.com/fundapps/TechDocs/blob/main/Adapptr/versions/v2.md#upload-positions-post-v2taskpositions
    data = {
        'snapshotDate': snapshote_date.strftime('%Y-%m-%d'),
        'dataProvider': 1, # https://github.com/fundapps/TechDocs/blob/main/Adapptr/versions/v2.md#available-nomenclatures-get-v2nomenclatures
        'excludeErroredAssets': True,
    }
    with open(file_path, 'rb') as file:
        files = {'positions': (file_path, file)}
        response = requests.post(url, files=files, data=data, auth=(username, password))
        if response.status_code == 200:
            return response.json()["id"]
        else:
            print(response)
            raise Exception("File failed to upload")

def check_status(task_id: str) -> Tuple[Dict[str, Any], Optional[Dict[str, List[str]]]]:
    """
    Checks the status of an upload for a specific task_id.
    
    Args:
        task_id (str): The unique id of the file upload
        
    Returns:
        (status, statusReport) Tuple[Dict[str, Any], Optional[Dict[str, List[str]]]]: a dictionary with status information and an optional dictionary of error/wanring messages

    Example:
        status: {"id":5,"name": "TransmittedWithExclusions"}
        statusReport: {"errors":[], "warnings":["Identifier 123: Missing data from Refintiv"]}
    """
    url = f"{base_url}task/{task_id}/status"
    response = requests.get(url, auth=(username, password))

    if response.status_code == 200:
        json_data = response.json()
        return (json_data["status"], json_data["statusReport"] if "statusReport" in json_data else None)
    else:
        print(response)
        raise Exception("error fetching status endpoint")

def main(args: List[str]):
    file_name = args[0]
    snapshot_date = datetime.strptime(args[1], "%Y-%m-%d").date()
    task_id = upload_file(file_name, snapshot_date)
    print(f"Adapptr file uploaded under id: {task_id}. Waiting for enrichment.")
    completed = False
    while not completed:
        time.sleep(30)
        (status, statusReport) = check_status(task_id)
        completed = status["id"] in [3, 5, 500]
    
    if status["id"] == 500:
        print("Adapptr file upload failed")
        if statusReport:
            for error in statusReport["errors"]:
                print(error)
        else:
            print(f"Unknown error code, contact support quoting your task id: {task_id}")
    elif status["id"] == 5:
        print("Adapptr file upload succeeded, with some warnings")
        if statusReport:
            for warning in statusReport["warnings"]:
                print(warning)
    elif status["id"] == 3:
        print("Adapptr file upload succeeded")

"""
Usage: python adapptr.py /path/to/file.csv 2024-02-28
"""
if __name__ == "__main__":
    main(sys.argv[1:])
