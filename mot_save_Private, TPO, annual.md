otor Quote Request:
{
  "value": 0,
  "cover_period": "annual",
  "year": 0,
  "class": "Motor",
  "coverage": "Private",
  "scope": "TPO",
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
    {
      "insurer_id": 2,
      "insurer": "APA",
      "rate_type": "Regular",
      "rate": "12000",
      "calculated": 12000,
      "minimum": 0,
      "basic_premium": 12000,
      "markup": 0,
      "markup_value": 0,
      "amount": 12000,
      "agent_com_rate": 1,
      "benefits": [],
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
    {
      "insurer_id": 9,
      "insurer": "Geminia",
      "rate_type": "Regular",
      "rate": "7500",
      "calculated": 7500,
      "minimum": 0,
      "basic_premium": 7500,
      "markup": 0,
      "markup_value": 0,
      "amount": 7500,
      "agent_com_rate": 1,
      "benefits": [],
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
    }
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
    "insurer_id": 2,
    "class": "Motor",
    "sub_class": "Private",
    "total_basic": 12000,
    "taxes": 94,
    "premium": 12094,
    "markup": 0,
    "markup_value": 0
  },
  "taxes": [
    {
      "tax_id": 1,
      "rate": "0.25",
      "amount": "30"
    },
    {
      "tax_id": 2,
      "rate": "0.2",
      "amount": "24"
    },
    {
      "tax_id": 3,
      "rate": "40",
      "amount": "40"
    }
  ],
  "vehicles": [
    {
      "rate": 12000,
      "coverage": "TPO",
      "regno": "KAA 00V",
      "make": "Honda",
      "model": "Civic",
      "body": "Metal",
      "color": "N/A",
      "chasis": "200",
      "engine": "200",
      "cc": 0,
      "yom": 1910,
      "seats": 0,
      "tonnage": 0,
      "value": 0,
      "basic_premium": 12000,
      "benefits": []
    }
  ]
}