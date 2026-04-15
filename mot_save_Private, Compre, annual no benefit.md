otor Quote Request:
Motor Quote Request:
{
  "value": 1000000,
  "cover_period": "annual",
  "year": 2026,
  "class": "Motor",
  "coverage": "Private",
  "scope": "Comprehensive",
  "subcover": "",
  "tonnage": 0,
  "pll": 0,
  "make": "",
  "model": "",
  "insurer_id": []
}
This is the motor response (MotorQuoteResponse?> getQuote)  
{
  "status": "success",
  "message": "Quote generated successfuly",
  "options": [
     "insurer_id": 5,
      "insurer": "Sanlam",
      "rate_type": "Regular",
      "rate": "6",
      "calculated": 60000,
      "minimum": 37500,
      "basic_premium": 60000,
      "markup": 0,
      "markup_value": 0,
      "amount": 68000,
      "agent_com_rate": 1,
      "benefits": [
        {
          "id": 5,
          "name": "PVT",
          "rate": "0.25",
          "calculated": 2500,
          "minimum": 3000,
          "amount": 3000,
          "included": false
        },
        {
          "id": 1,
          "name": "Excess Protector",
          "rate": "0.25",
          "calculated": 2500,
          "minimum": 5000,
          "amount": 5000,
          "included": false
        }
      ],
      "taxes": [
        {
          "id": 1,
          "tax": "PCF",
          "rate": "0.25",
          "calculations": "On Basic"
        },
        {
          "id": 2,
          "tax": "ITL",
          "rate": "0.2",
          "calculations": "On Basic"
        },
        {
          "id": 3,
          "tax": "STAMP DUTY",
          "rate": "40",
          "calculations": "Duty"
        }
      ]
    }, 
  ]
}
💾 Quote cached for future reuse


THIS IS THE MotorSave Payload JSON: 
{
  "client": {
    "name": "Gloria Sifa",
    "email": "gloria@gmail.com",
    "phone": "0789000000",
    "idno": "0789000000",
    "pin": "0789000000",
    "risk_manager_id": 1,
    "sales_person_id": null,
    "branch_id": 1
  },
  "policy": {
    "cover_period": "annual",
    "start_date": "2026-04-02",
    "end_date": "2027-04-01",
    "insurer_id": 5,
    "class": "Motor",
    "sub_class": "Private",
    "total_basic": 60000,
    "taxes": 310,
    "premium": 60310,
    "markup": 0,
    "markup_value": 0
  },
  "taxes": [
    {
      "tax_id": 1,
      "rate": "0.25",
      "amount": "150"
    },
    {
      "tax_id": 2,
      "rate": "0.2",
      "amount": "120"
    },
    {
      "tax_id": 3,
      "rate": "40",
      "amount": "40"
    }
  ],
  "vehicles": [
    {
      "rate": 6,
      "coverage": "Comprehensive",
      "regno": "KAA 004S",
      "make": "Bima",
      "model": "x",
      "body": "Metal",
      "color": "N/A",
      "chasis": "201",
      "engine": "201",
      "cc": 0,
      "yom": 2026,
      "seats": 0,
      "tonnage": 0,
      "value": 0,
      "basic_premium": 60000,
      "benefits": []
    }
  ]
}