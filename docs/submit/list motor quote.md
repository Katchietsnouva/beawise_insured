so bro lets meake tis fom ttt submists to :
{{local_url}}/motor/quote
https://demo.inscloud.net/api/motor/quote
X-Agent-Code n X-Agent-Key requred, bearer token too

usin: 
payload
{
    "value": 800000,
    "cover_period": "tor", // annual/tor
    "year": 2016,
    "class": "Motor", //Motor/Tuktuk/Motorcycle
    "coverage": "Private",
    "scope": "TPO", //TPO/Comprehensive
    "subcover": "",
    "tonnage": 0,
    "make": "Toyota",
    "model": "Land Cruiser",
    "insurer_id": []  // Multiple insurer IDs
}

possible feedbacks inclue:

{
    "status": "error",
    "message": "Error 404",
    "errors": "No record found"
}

{
    "status": "error",
    "message": "Invalid credentials for the provided agent code and key."
}


wen te rit one comes i will sare wit u but lers assumes we also et a 
