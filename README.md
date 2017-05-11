## Development
1. do `bundle install`
2. run tests with `rake`
3. boot app via `foreman start`
4. visit `localhost:9292`

## API

(mainly for bots and stuff)

**GET /expanding_brain(.json)**
*(Retrieve the url for a generated expanding brain image)*

Request
- **id** *String* (required)

```shell
$ curl -H "Content-Type: application/json" \
-X GET localhost:9292/expanding_brain.json?id=something -i
```

Response
- **url**

```json
{
  "url":"https://..."
}
```

**POST /expanding_brain(.json)**
*(Generate an expanding brain image)*

Request
- **brains** *Array* (required)
  - ***** *Hash* (at least one is required)
    - **text** *String* (required)
    - **_** _ (there will be more options eventually)

```shell
$ curl -H "Content-Type: application/json" \
       -d '{"brains":[{"text":"a"},{"text":"b"},{"text":"c"},{"text":"d"}]}' \
       -X POST localhost:9292/expanding_brain.json -i
```

Response
- **name** *String*
- **url** *String*

```json
{
  "name":"identifier",
  "url":"https://..."
}```
