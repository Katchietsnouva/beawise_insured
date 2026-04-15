get
https://demo.inscloud.net/api/agent/renewals:

X-Agent-Code n X-Agent-Key requred, bearer token too


can use body of:

{
    "starting": "2026-03-01",
    "ending": "2026-04-30",
    "page": 1,
    "per_page": 3
}

response:


on suces it can  return:

{
    "status": "success",
    "message": "Policies retrieved successfully",
    "policy": [],
    "pagination": {
        "current_page": 1,
        "per_page": 3,
        "total": 0,
        "last_page": 1,
        "from": null,
        "to": null,
        "has_more": false,
        "next_page_url": null,
        "prev_page_url": null
    }
}

or:

{
    "status": "success",
    "message": "Policies retrieved successfully",
    "policy": [
        {
            "client": {
                "name": "Chris Kamau",
                "client_no": "CH001",
                "mobile": "0706233444",
                "email": "chris@gmail.com"
            },
            "policy": {
                "id": 219,
                "risknote": 100193,
                "insurer": "NCBA IG",
                "product": "Motor Insurance",
                "starting": "2025-09-26",
                "ending": "2026-03-30",
                "sub_cover": "Motor",
                "motor_class": "Private",
                "transaction": "Policy",
                "policy_no": "P/01/09089/2025",
                "sales_type": "New Business",
                "sum_insured": 8000000,
                "basic": 320000,
                "tax": 1480,
                "amount": 321480,
                "receipted": 321480,
                "balance": 0,
                "com_rate": 10,
                "commission": 2880,
                "reg": "KDV 100T"
            }
        }
    ],
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



an example of a failure is :


{
    "status": "error",
    "message": "Invalid input",
    "errors": {
        "agent_code": [
            "Invalid credentials."
        ]
    }
}


or:

{
    "status": "error",
    "message": "Invalid credentials."
}