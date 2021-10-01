## The Name Guesser

### Requirements
Write a small web-service which offers the following functionality: for a given **last name
(surname)**, the service should respond with the **country** it's most likely to come from.

The request will be using GET, proving the parameter “name”, e.g.
 ```sh  
 curl “http://.../country_guess?name=Müller”   
 ```
The response format should be JSON and including three keys:
- guessed_country: [DE, US, NL, ...]
- requested_name: [echo name parameter]
- time_processed: [time passed by while guessing the country]

Any (plausible) way of guessing the country is okay (e.g. heuristic, database, external
web-service, whatever :)) \
Of course our service should be secure (and fast if possible)
### User Story
- As a **Developer** 
  I want to **consume an API endpoint that will provide country information on submitting a surname** 
  so that **I can use the data for decision making**

### Basic Implementation Details
- RoR app (-- api flag)
- API Versioning using routing concerns
- Token based authentication (extremely simplified)
- Rate Limiting (1req/2secs - for demonstration purposes)

### Areas for Improvement
- 

### Endpoint Documentation
![Screenshot 2021-10-01 at 5 51 08 PM](https://user-images.githubusercontent.com/12958182/135640865-ba15ad22-afef-490b-9eeb-ffa9c7bf1783.png)

