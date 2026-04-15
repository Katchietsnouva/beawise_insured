get
https://demo.inscloud.net/api/agent/statement

X-Agent-Code n X-Agent-Key requred, bearer token too


can use body of:
{
    "start_date": "2026-01-01",
    "end_date": "2026-12-31",
    "page": 1,
    "per_page": 3
}

response:

{
    "status": "success",
    "message": "Statement retrieved successfully",
    "starting": "2026-01-01",
    "ending": "2026-12-31",
    "data": {
        "sections": [
            {
                "Date": "2026-01-01",
                "Ref": "",
                "Type": "",
                "policy_no": "",
                "Policy ID": "",
                "Trans ID": "",
                "client": "",
                "description": "Opening Balance",
                "DR": 0,
                "CR": 0,
                "Balance": 0
            }
        ],
        "totals": {
            "tdr": 0,
            "tcr": 0,
            "tbl": 0
        },
        "pagination": {
            "current_page": 1,
            "per_page": 3,
            "total": 1,
            "last_page": 1,
            "from": 1,
            "to": 1,
            "has_more": false,
            "next_page_url": null,
            "prev_page_url": null
        }
    }
}



updated response:

{
    "status": "success",
    "message": "Statement retrieved successfully",
    "starting": "2026-01-01",
    "ending": "2026-03-31",
    "data": {
        "sections": [
            {
                "Date": "2026-01-01",
                "Ref": "",
                "Type": "",
                "policy_no": "",
                "Policy ID": "",
                "Trans ID": "",
                "client": "",
                "description": "Opening Balance",
                "DR": 0,
                "CR": 0,
                "Balance": 0
            },
            {
                "Date": "2026-03-20",
                "Ref": "100543",
                "Type": "UW",
                "policy_no": "23421/2026",
                "Policy ID": 587,
                "Trans ID": 587,
                "client": "Rashid Moha",
                "description": "Motor Insurance",
                "DR": 0,
                "CR": 400,
                "Balance": -400
            }
        ],
        "totals": {
            "tdr": 0,
            "tcr": 400,
            "tbl": -400
        },
        "pagination": {
            "current_page": 1,
            "per_page": 15,
            "total": 2,
            "last_page": 1,
            "from": 1,
            "to": 2,
            "has_more": false,
            "next_page_url": null,
            "prev_page_url": null
        }
    }
}



posible errors:

 {
    "status": "error",
    "message": "Invalid input",
    "errors": {
        "agent_code": [
            "Invalid credentials."
        ]
    }
}

{
    "status": "error",
    "message": "Invalid credentials."
}