so bro i wanna pass the follwing:

This is the motor response:
{
  "status": "success",
  "message": "Quote generated successfuly",
  "options": [
    {
      "insurer_id": 2,
      "insurer": "APA",
      "rate_type": "Regular",
      "rate": 557,
      "calculated": 557,
      "minimum": null,
      "basic_premium": 557,
      "markup": 200,
      "markup_value": 200,
      "agent_com_rate": 0,
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
      "rate": 557,
      "calculated": 557,
      "minimum": null,
      "basic_premium": 557,
      "markup": 200,
      "markup_value": 200,
      "agent_com_rate": 0,
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




This is the payload for request:
{
  "value": 1000000,
  "cover_period": "annual",
  "year": 2019,
  "class": "Motor",
  "coverage": "Private",
  "scope": "Comprehensive",
  "subcover": "",
  "tonnage": 0,
  "make": "",
  "model": "",
  "insurer_id": []
}
This is the motor response (MotorQuoteResponse?> getQuote) {status: success, message: Quote generated successfuly, options: [{insurer_id: 5,
insurer: Sanlam, rate_type: Regular, rate: 4, calculated: 40000, minimum: 37500, basic_premium: 40000, markup: 0, markup_value: 0,
agent_com_rate: 1, benefits: [{id: 5, name: PVT, rate: 0.25, calculated: 2500, minimum: 3000, amount: 3000}, {id: 1, name: Excess Protector,
rate: 0.25, calculated: 2500, minimum: 5000, amount: 5000}], taxes: [{id: 1, tax: PCF, rate: 0.25, calculations: On Basic}, {id: 2, tax: ITL,
rate: 0.2, calculations: On Basic}, {id: 3, tax: STAMP DUTY, rate: 40, calculations: Duty}]}, {insurer_id: 2, insurer: APA, rate_type: Regular,
rate: 4.5, calculated: 45000, minimum: 35000, basic_premium: 45000, markup: 0, markup_value: 0, agent_com_rate: 1, benefits: [{id: 5, name: PVT,
rate: 0.25, calculated: 2500, minimum: 2500, amount: 2500}, {id: 1, name: Excess Protector, rate: 0.25, calculated: 2500, minimum: 2500, amount:
2500}], taxes: [{id: 1, tax: PCF, rate: 0.25, calculations: On Basic}, {id: 2, tax: ITL, rate: 0.2, calculations: On Basic}, {id: 3, tax: STAMP
DUTY, rate: 40, calculations: Duty}]}, {insurer_id: 6, insurer: APA Medical, rate_type: Regular, rate: 6.5, calculated: 65000, minimum: 35000,
basic_premium: 65000, markup: 0, markup_value: 0, agent_com_rate: 1, benefits: [{id: 5, name: PVT, rate: 0.25, calculated: 2500, minimum: 2500,
amount: 2500}, {id: 1, name: Excess Protector, rate: 2.5, calculated: 25000, minimum: 20000, amount: 25000}], taxes: [{id: 1, tax: PCF, rate:
0.25, calculations: On Basic}, {id: 2, tax: ITL, rate: 0.2, calculations: On Basic}, {id: 3, tax: STAMP DUTY, rate: 40, calculations: Duty}]},
{insurer_id: 13, insurer: Jubilee Allianz, rate_type: Regular, rate: 6.5, calculated: 65000, minimum: 37500, basic_premium: 65000, markup: 0,
markup_value: 0, agent_com_rate: 1, benefits: [{id: 5, name: PVT, rate: 0.25, calculated: 2500, minimum: 2500, amount: 2500}, {id: 1, name:
Excess Protector, rate: 0.25, calculated: 2500, minimum: 2500, amount: 2500}], taxes: [{id: 1, tax: PCF, rate: 0.25, calculations: On Basic},
{id: 2, tax: ITL, rate: 0.2, calculations: On Basic}, {id: 3, tax: STAMP DUTY, rate: 40, calculations: Duty}]}, {insurer_id: 22, insurer:
Fidelity, rate_type: Regular, rate: 4.75, calculated: 47500, minimum: 0, basic_premium: 47500, markup: 0, markup_value: 0, agent_com_rate: 1,
benefits: [{id: 5, name: PVT, rate: 0.25, calculated: 2500, minimum: 2500, amount: 2500}, {id: 1, name: Excess Protector, rate: 0.25,
calculated: 2500, minimum: 2500, amount: 2500}], taxes: [{id: 1, tax: PCF, rate: 0.25, calculations: On Basic}, {id: 2, tax: ITL, rate: 0.2,
calculations: On Basic}, {id: 3, tax: STAMP DUTY, rate: 40, calculations: Duty}]}, {insurer_id: 12, insurer: Prudential Life, rate_type:
Regular, rate: 4, calculated: 40000, minimum: 20000, basic_premium: 40000, markup: 0, markup_value: 0, agent_com_rate: 1, benefits: [{id: 5,
name: PVT, rate: 0.03, calculated: 250, minimum: 2500, amount: 2500}, {id: 1, name: Excess Protector, rate: 0.25, calculated: 2500, minimum:
2500, amount: 2500}], taxes: [{id: 1, tax: PCF, rate: 0.25, calculations: On Basic}, {id: 2, tax: ITL, rate: 0.2, calculations: On Basic}, {id:
3, tax: STAMP DUTY, rate: 40, calculations: Duty}]}]}
This is the motor response:
{
  "status": "success",
  "message": "Quote generated successfuly",
  "options": [
    {
      "insurer_id": 5,
      "insurer": "Sanlam",
      "rate_type": "Regular",
      "rate": 4,
      "calculated": 40000,
      "minimum": 37500,
      "basic_premium": 40000,
      "markup": 0,
      "markup_value": 0,
      "agent_com_rate": 1,
      "benefits": [
        {
          "id": 5,
          "name": "PVT",
          "rate": "0.25",
          "calculated": 2500,
          "minimum": 3000,
          "amount": 3000
        },
        {
          "id": 1,
          "name": "Excess Protector",
          "rate": "0.25",
          "calculated": 2500,
          "minimum": 5000,
          "amount": 5000
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
    {
      "insurer_id": 2,
      "insurer": "APA",
      "rate_type": "Regular",
      "rate": 4.5,
      "calculated": 45000,
      "minimum": 35000,
      "basic_premium": 45000,
      "markup": 0,
      "markup_value": 0,
      "agent_com_rate": 1,
      "benefits": [
        {
          "id": 5,
          "name": "PVT",
          "rate": "0.25",
          "calculated": 2500,
          "minimum": 2500,
          "amount": 2500
        },
        {
          "id": 1,
          "name": "Excess Protector",
          "rate": "0.25",
          "calculated": 2500,
          "minimum": 2500,
          "amount": 2500
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
    {
      "insurer_id": 6,
      "insurer": "APA Medical",
      "rate_type": "Regular",
      "rate": 6.5,
      "calculated": 65000,
      "minimum": 35000,
      "basic_premium": 65000,
      "markup": 0,
      "markup_value": 0,
      "agent_com_rate": 1,
      "benefits": [
        {
          "id": 5,
          "name": "PVT",
          "rate": "0.25",
          "calculated": 2500,
          "minimum": 2500,
          "amount": 2500
        },
        {
          "id": 1,
          "name": "Excess Protector",
          "rate": "2.5",
          "calculated": 25000,
          "minimum": 20000,
          "amount": 25000
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
    {
      "insurer_id": 13,
      "insurer": "Jubilee Allianz",
      "rate_type": "Regular",
      "rate": 6.5,
      "calculated": 65000,
      "minimum": 37500,
      "basic_premium": 65000,
      "markup": 0,
      "markup_value": 0,
      "agent_com_rate": 1,
      "benefits": [
        {
          "id": 5,
          "name": "PVT",
          "rate": "0.25",
          "calculated": 2500,
          "minimum": 2500,
          "amount": 2500
        },
        {
          "id": 1,
          "name": "Excess Protector",
          "rate": "0.25",
          "calculated": 2500,
          "minimum": 2500,
          "amount": 2500
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
    {
      "insurer_id": 22,
      "insurer": "Fidelity",
      "rate_type": "Regular",
      "rate": 4.75,
      "calculated": 47500,
      "minimum": 0,
      "basic_premium": 47500,
      "markup": 0,
      "markup_value": 0,
      "agent_com_rate": 1,
      "benefits": [
        {
          "id": 5,
          "name": "PVT",
          "rate": "0.25",
          "calculated": 2500,
          "minimum": 2500,
          "amount": 2500
        },
        {
          "id": 1,
          "name": "Excess Protector",
          "rate": "0.25",
          "calculated": 2500,
          "minimum": 2500,
          "amount": 2500
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
    {
      "insurer_id": 12,
      "insurer": "Prudential Life",
      "rate_type": "Regular",
      "rate": 4,
      "calculated": 40000,
      "minimum": 20000,
      "basic_premium": 40000,
      "markup": 0,
      "markup_value": 0,
      "agent_com_rate": 1,
      "benefits": [
        {
          "id": 5,
          "name": "PVT",
          "rate": "0.03",
          "calculated": 250,
          "minimum": 2500,
          "amount": 2500
        },
        {
          "id": 1,
          "name": "Excess Protector",
          "rate": "0.25",
          "calculated": 2500,
          "minimum": 2500,
          "amount": 2500
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
    }
  ]
}