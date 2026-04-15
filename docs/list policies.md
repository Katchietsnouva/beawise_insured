get
https://demo.inscloud.net/api/agent/policies

X-Agent-Code n X-Agent-Key requred, bearer token too


can use body of:
{ 
    "page": 1,
    "per_page": 2
    status: 0 // 0--> unverifed, 1-> , 2->
}

response:


{
    "status": "success",
    "message": "Policies retrieved successfully",
    "policy": [],
    "pagination": {
        "current_page": 1,
        "per_page": 10,
        "total": 0,
        "last_page": 1,
        "from": null,
        "to": null,
        "has_more": false,
        "next_page_url": null,
        "prev_page_url": null
    }
}

or :

{
    "status": "success",
    "message": "Policies retrieved successfully",
    "policy": [
        {
            "client": {
                "name": "Fredrick Otieno",
                "client_no": "FR001",
                "mobile": "0718917211",
                "email": "fredmaxton2@gmail.com"
            },
            "policy": {
                "id": 71,
                "risknote": 100058,
                "insurer": "Mayfair",
                "product": "Motor Insurance",
                "starting": "2026-03-05",
                "ending": "2027-03-04",
                "sub_cover": "Motor",
                "motor_class": "Private",
                "transaction": "Policy",
                "policy_no": null,
                "sales_type": "New Business",
                "sum_insured": 5000000,
                "basic": 225000,
                "tax": 1052.5,
                "amount": 226052.5,
                "receipted": 0,
                "balance": 226052.5,
                "com_rate": 20,
                "commission": 3847.5,
                "reg": "KDX223U"
            }
        },
        {
            "client": {
                "name": "John Doe2",
                "client_no": "JO002",
                "mobile": "254718888888",
                "email": "johndoe@example.com"
            },
            "policy": {
                "id": 4,
                "risknote": 100004,
                "insurer": "APA",
                "product": "Contractual Liability",
                "starting": "2025-08-01",
                "ending": "2026-07-31",
                "sub_cover": null,
                "motor_class": null,
                "transaction": "Policy",
                "policy_no": "4534534",
                "sales_type": "New Business",
                "sum_insured": 100000,
                "basic": 4000,
                "tax": 58,
                "amount": 4058,
                "receipted": 14103,
                "balance": -10045,
                "com_rate": 10,
                "commission": 71.82,
                "reg": null
            }
        },
        {
            "client": {
                "name": "Edwin Abungu",
                "client_no": "ED001",
                "mobile": "23",
                "email": "edwin@inscloud.net"
            },
            "policy": {
                "id": 28,
                "risknote": 100026,
                "insurer": "APA",
                "product": "Domestic Package",
                "starting": "2025-12-03",
                "ending": "2026-12-02",
                "sub_cover": null,
                "motor_class": null,
                "transaction": "Policy",
                "policy_no": null,
                "sales_type": "New Business",
                "sum_insured": 1000000,
                "basic": 30000,
                "tax": 175,
                "amount": 30175,
                "receipted": 30175,
                "balance": 0,
                "com_rate": 20,
                "commission": 1080,
                "reg": null
            }
        }
    ],
    "pagination": {
        "current_page": 1,
        "per_page": 3,
        "total": 3,
        "last_page": 1,
        "from": 1,
        "to": 3,
        "has_more": false,
        "next_page_url": null,
        "prev_page_url": null
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
or

{
    "status": "error",
    "message": "Invalid credentials."
}

or a crush ie html respomseac