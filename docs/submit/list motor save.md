url: {{local_url}}/motor/save
https://demo.inscloud.net/api/motor/save

payload

{
    "client": {
        "name": "STANLEY MUGO",
        "email": "muriithindekere@gmail.com",
        "phone": "0711650861",
        "idno": "12345678",
        "pin": "A014017312Z",
        "risk_manager_id": 1,
        "sales_person_id": null,
        "branch_id": 1
    },
    "policy": {
        "cover_period": "tor", // annual/tor
        "start_date": "2026-01-15",
        "end_date": "2027-01-15",
        "insurer_id": 1,
        "class": "Motor",
        "sub_class": "Private",
        "total_basic": 42000,
        "taxes": 6256,
        "premium": 48256,
        "markup": 1,
        "markup_value": 480
    },
    "taxes": [
        {
            "tax_id": 1,
            "rate": "0.0025",
            "amount": "120.0"
        },
        {
            "tax_id": 2,
            "rate": "0.002",
            "amount": "96.0"
        },
        {
            "tax_id": 3,
            "rate": "40.0",
            "amount": "40.0"
        }
    ],
    "vehicles": [
        {
            "rate": 6,
            "coverage": "Comprehensive",
            "regno": "KCL 620B",
            "make": "AUDI",
            "model": "A3",
            "body": "Saloon",
            "color": "",
            "chasis": "1254696",
            "engine": "",
            "cc": 0,
            "yom": 1910,
            "seats": 0,
            "tonnage": 0,
            "value": 1200000,
            "basic_premium": 42000,
            "benefits": [
                {
                    "benefit_id": 1,
                    "rate": 0.25,
                    "premium": 2500
                },
                {
                    "benefit_id": 5,
                    "rate": 0.25,
                    "premium": 2500
                }
            ]
        }
    ]
}



possble feedbacks:
{
    "status": "error",
    "message": "Invalid credentials for the provided agent code and key."
}


{
    "message": "Validation failed.",
    "errors": {
        "client.name": [
            "The client.name field is required."
        ],
        "client.email": [
            "The client.email field is required."
        ],
        "client.phone": [
            "The client.phone field is required."
        ],
        "client.idno": [
            "The client.idno field is required."
        ],
        "client.risk_manager_id": [
            "The client.risk manager id field is required."
        ],
        "client.branch_id": [
            "The client.branch id field is required."
        ],
        "policy.start_date": [
            "The policy.start date field is required."
        ],
        "policy.end_date": [
            "The policy.end date field is required."
        ],
        "policy.insurer_id": [
            "The policy.insurer id field is required."
        ],
        "policy.class": [
            "The policy.class field is required."
        ],
        "policy.total_basic": [
            "The policy.total basic field is required."
        ],
        "policy.taxes": [
            "The policy.taxes field is required."
        ],
        "policy.premium": [
            "The policy.premium field is required."
        ],
        "vehicles": [
            "The vehicles field is required."
        ],
        "taxes": [
            "The taxes field is required."
        ]
    }
}

if well:
{
    "message": "Policy created successfully.",
    "risknote": 100509,
    "client_no": "LA001",
    "client_key": "IC_vX1oAEF$wvUcTIzSsXD?Hg7yvoDNsku6sZwKK4be2nQShkxdXb>{4GTU0VR96]TBb"
}


