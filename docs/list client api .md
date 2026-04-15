client api: GET
https://demo.inscloud.net/api/agent/clients

X-Agent-Code n X-Agent-Key requred, bearer token too

body as  {
    "page": 1,
    "per_page": 1,
}


possibel err response: 
{
    "status": "error",
    "message": "Invalid credentials for the provided agent code and key."
}


{
    "status": "success",
    "message": "Clients retrieved successfully",
    "clients": [
        {
            "name": "Baraza Ken",
            "client_no": "BA001",
            "mobile": "254720984259",
            "email": "kena@gmIL.COM"
        }
    ],
    "pagination": {
        "current_page": 1,
        "per_page": 1,
        "total": 6,
        "last_page": 6,
        "from": 1,
        "to": 1,
        "has_more": true,
        "next_page_url": "https://demo.inscloud.net/api/agent/clients?page=2",
        "prev_page_url": null
    }
}


if i put :
body as  
{
    "page": 1,
    "per_page": 4
} 

response: 
{
    "status": "success",
    "message": "Clients retrieved successfully",
    "clients": [
        {
            "name": "Paul Peter",
            "client_no": "PA005",
            "mobile": "07000000",
            "email": "paul@gmail.com"
        },
        {
            "name": "Baraza Ken",
            "client_no": "BA001",
            "mobile": "254720984259",
            "email": "kena@gmIL.COM"
        },
        {
            "name": "Jane",
            "client_no": "JA008",
            "mobile": "07000",
            "email": "dsfds@gmail.com"
        },
        {
            "name": "s s",
            "client_no": "S 001",
            "mobile": "070000000003",
            "email": "s@gmail.aom"
        }
    ],
    "pagination": {
        "current_page": 1,
        "per_page": 4,
        "total": 7,
        "last_page": 2,
        "from": 1,
        "to": 4,
        "has_more": true,
        "next_page_url": "https://demo.inscloud.net/api/agent/clients?page=2",
        "prev_page_url": null
    }
}



//improvements on the client scren:
 how can we add the paylaod to that get client as diefined intnthe ui then update the clients screen to  have the pagination stuff below the dearch bar , then make the search bar work so as to filtr. let s add a filter to the  right in large screen as is activated when the user starts to type on the search bar. lets make th filter stuff be the keys inteh modle itsels. 
 (or whatever u can thisnk of tho make the filter stuff wow lke the rest of the ui.
 
 )
 lets also 
add te pagination stuff to the view bro. it shouldl incldue the objects in the  modle:





// payload
class ClientsRequest {
  final int page;
  final int perPage;

  ClientsRequest({this.page = 1, this.perPage = 10});

  Map<String, dynamic> toJson() => {"page": page, "per_page": perPage};
}




or most of them. on active, lets store the data such taht if for eg the usr adds a value to the pagicvnation, it sets fetchign . but the currenlty in view do not go or go dependin if theri number is less or greater then the value in the payload

the paginatin is passive that includes this:



class Pagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int from;
  final int to;
  final bool hasMore;
  final String? nextPageUrl;
  final String? prevPageUrl;


for the per page is active tantd thats what the code deternaids if it will refetch. lets not makt the process expensiev rbro, if fo reg we have 4 items in teh view, if user says 7 , we spawn ghsot cards at the last one theat will be fileed if theose data become available. initailly, during fetching, lets add ghoset cards in addition to the spinner



if user seees 5 card s ans says per pagte 3, the pagination takes effec, we spilt the curenlt data into 2 pages,tehn preseignteh next, we can go tho the next page. 


do u understand the level of intelligence her that we need to achive bro?


