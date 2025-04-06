+++
title="Using RestClient"
+++

## Update `UserRestClient`

Open `UserRestClient` and add a `RestClient` object. This object can be instantiated by using a `RestClient.Builder` object injected into the constructor:

```editor:select-matching-text
file: ~/exercises/src/main/java/dev/danvega/httpusers/user/UserRestClient.java
text: "// add the RestClient variable and constructor"
description: Add RestClient
```

```java
private final RestClient restClient;

public UserRestClient(RestClient.Builder builder) {
    this.restClient = builder
            .baseUrl("https://jsonplaceholder.typicode.com/")
            .build();
}
```

In the `RestClient.Builder`, you specify the `baseUrl`. When you create new services, this lets you specify only the URI that comes after the base URL specified here:

Note that `RestClient` is an interface, so you cannot create an instance of it. This interface defines a few static factory methods to create a new instance of `DefaultRestClientBuilder`, which implements the `RestClient.Builder` interface. While you could follow this route, Spring Boot's auto-configuration simplifies the process by creating an instance of this class for you. As it is in the application context, you can request an instance through constructor injection.

Now that you have a `RestClient` object ready to go, you can implement two methods.

```editor:select-matching-text
file: ~/exercises/src/main/java/dev/danvega/httpusers/user/UserRestClient.java
text: "// add findAll and findById"
description: Implement methods
```

```java
public List<User> findAll() {
    return restClient.get()
            .uri("/users")
            .retrieve()
            .body(new ParameterizedTypeReference<>() {});
}

public User findById(Integer id) {
	return restClient.get()
            .uri("/users/{id}", id)
            .retrieve()
            .body(User.class);
}
```

## Update `UserController`

Now that you have written the `RestClient` implementation, you need to connect it to the `UserController` so that you can call the service and test by using your terminal:

```editor:select-matching-text
file: ~/exercises/src/main/java/dev/danvega/httpusers/user/UserController.java
text: "// add new variable and constructor for UserRestClient"
description: Add UserRestClient
```

```java
private final UserRestClient client;

public UserController(UserRestClient client) {
    this.client = client;
}
```

You can now use `UserRestClient` to call the methods you just wrote:

```editor:select-matching-text
file: ~/exercises/src/main/java/dev/danvega/httpusers/user/UserController.java
text: "// add findAll and findById endpoints"
description: Add endpoints
```

```java
@GetMapping("")
List<User> findAll() {
    return client.findAll();
}

@GetMapping("/{id}")
User findById(@PathVariable Integer id) {
    return client.findById(id);
}
```

## Test

You can now test the `UserController` endpoints. Note that Spring Boot Developer Tools was continually building and deploying your application as you made changes.

You can test the `findAll` endpoint by running the command in the terminal:

```execute
http :8080/users
```

This service should return a list of User objects, similar to the following:

```json
[
    {
        "address": {
            "city": "Gwenborough",
            "geo": {
                "latitude": null,
                "longitude": null
            },
            "street": "Kulas Light",
            "suite": "Apt. 556",
            "zipcode": "92998-3874"
        },
    ...
    },
    {
        "address": {
            "city": "Wisokyburgh",
            "geo": {
                "latitude": null,
                "longitude": null
            },
            "street": "Victor Plains",
            "suite": "Suite 879",
            "zipcode": "90566-7771"
        },
    ...
    },
    {
        "address": {
            "city": "McKenziehaven",
            "geo": {
                "latitude": null,
                "longitude": null
            },
            "street": "Douglas Extension",
            "suite": "Suite 847",
            "zipcode": "59590-4157"
    },
    ...
...
]
```

You can also call the `findById` endpoint to return a single user:

```execute
http :8080/users/1
```

```json
{
    "address": {
        "city": "Gwenborough",
        "geo": {
            "latitude": null,
            "longitude": null
        },
        "street": "Kulas Light",
        "suite": "Apt. 556",
        "zipcode": "92998-3874"
    },
    "company": {
        "bs": "harness real-time e-markets",
        "catchPhrase": "Multi-layered client-server neural-net",
        "name": "Romaguera-Crona"
    },
    "email": "Sincere@april.biz",
    "id": 1,
    "name": "Leanne Graham",
    "phone": "1-770-736-8031 x56442",
    "username": "Bret",
    "website": "hildegard.org"
}
```
