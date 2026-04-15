
https://demo.inscloud.net/api/agent/dashboard:
 it cosnunms no paarameter and is a GET:


 adn it returns :

 {
    "status": "success",
    "message": "Dashboard retrieved successfully",
    "data": {
        "number_of_clients": 38,
        "policies": {
            "count": 1,
            "gross_premium": 12000,
            "receipted": 0,
            "balance": 12000
        },
        "renewals_due": 1,
        "commission": 400,
        "quotes": 23,
        "period": {
            "year_start": "2026-01-01",
            "year_end": "2026-12-31",
            "month_start": "2026-03-01",
            "month_end": "2026-03-31"
        }
    }
}


posible error include;
{
    "status": "error",
    "message": "Invalid credentials."
}
