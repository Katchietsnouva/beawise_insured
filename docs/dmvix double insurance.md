https://demo.inscloud.net/api/dmvic/double-insurance


could be:

{
    "success": true,
    "CoverEndDate": "16/03/2027",
    "CertificateNo": "C33743424",
    "insurer": "Occidental Insurance Company Ltd.",
    "registration": "KCX352U",
    "chassis": "NT31-232038"
}


or:

{
    "success": true,
    "CoverEndDate": "27/05/2026",
    "CertificateNo": "B14153076",
    "insurer": "Directline Assurance Company Ltd.",
    "registration": "KCY352U",
    "chassis": "DEJFS-147241"
}

or


{
    "success": false,
    "error_code": "ER0016",
    "message": "No Records Found"
}


dependin on :

{
    "registration": "KCa352U",
    "start_date": "2026-03-20",
    "expiring": "2026-05-16"
}

{
    "registration": "KCy352U",
    "start_date": "2026-03-20",
    "expiring": "2026-05-16"
}

or
{
    "registration": "KCX352U",
    "start_date": "2026-03-20",
    "expiring": "2026-05-16"
}

