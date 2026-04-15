get
<!-- https://demo.inscloud.net/api/agent/policies -->
/agent/policy/{id}
https://demo.inscloud.net/api/agent/policy/{id}

X-Agent-Code n X-Agent-Key requred, bearer token too


can use body of:
 
response:
{   
    "status":"error",
    "message":"Unauthorized policy access.",
    "errors":{
        "policy_id":["Policy does not belong to this agent."]
    }
}




{
  "status": "success",
  "policy": {
    "id": 563,
    "marine_dmvic": 563,
    "status": 0,

    "transaction": "Policy",
    "policy_no": null,
    "insurer": "Geminia",
    "client": "Allan Mwenja",
    "product": "Motor",
    "sub_cover": null,
    "start_date": "2026-03-10",
    "end_date": "2026-04-09",
    "sales_type": "New",
    "risk_note": 100519,
    "risk_note_link": "https://demo.inscloud.net/public-policy-pdf/eyJpdiI6ImdJKzFzUkFIenZXQlZ4bnBNVTd3ZFE9PSIsInZhbHVlIjoiZUplQmxCSURHSTFkMWRQUHlRTTZ6Zz09IiwibWFjIjoiZjYyZmI0MjJmMmI0YTc0ZTY5MWFhNjI3ZWU3YTllOTYwMTkwMWU5ZGJhNmUwYThiODAzY2M5ODY5ZWJlNTljNiIsInRhZyI6IiJ9",
    "sum_insured": 1000000,
    "premium": 800,
    "currency": "KES",
    "receipted": 0,
    "balance": 800,
    "receipt_allocations": [],
    "vehicles": [
      "A"
    ],
    "claims": [],
    "policy_documents": [],
    "client_documents": []
  }
}

or :
 if