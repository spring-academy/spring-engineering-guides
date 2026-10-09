+++
title="Lab Overview"
+++

This guide lets you follow along with [Dan Vega's YouTube video](https://www.youtube.com/watch?v=aR580OCEp7w) on how to use HTTP Interfaces with the recently introduced `RestClient`.

> **Version Note**: The functionality you are about to use was introduced in Spring Framework 6.1. This version of Spring Framework is consumed by Spring Boot 3.2 and later. Be sure that you use compatible versions if you are outside of this lab environment.

You can follow Dan's video and write the same code as he does. While this lab could be completed as a standalone exercise, it is recommended that you complete this lab in conjunction with Dan's video.

This lab focuses on a single web application that talks to a public API. You start by writing the `RestClient` implementation to understand the code required to make the connection. Then, as an alternate approach, you can look at how HTTP Interfaces can simplify your codebase.

## Why HTTP Interfaces

If you have a Spring Boot application and you need to talk to another service, you have a few different ways to do so. You could use the recently introduced [`RestClient`](https://docs.spring.io/spring-framework/reference/integration/rest-clients.html#rest-restclient) to make the connection, but then you need to write the code yourself. If you are interested in writing almost no code to talk to another service, consider using [HTTP Interfaces](https://docs.spring.io/spring-framework/reference/integration/rest-clients.html#rest-http-interface).

## Dev Tools

In this lab, you use [Spring Boot DevTools](https://docs.spring.io/spring-boot/docs/3.2.0/reference/html/using.html#using.devtools) to automatically deploy the application each time you save your work. This means that you need only start the application once and need not worry about continually stopping and restarting as you make changes.

**▶️ Start the application now**

```editor:select-matching-text
file: ~/exercises/src/main/java/dev/danvega/httpusers/HttpUsersApplication.java
text: "public static void main(String[] args)"
description: "Right-click ➡️ Run Java"
```

## Project Dependencies

The project has a dependency for `Spring Web`. This dependency brings in the `RestClient` functionality and lets you interact with outside services in an imperative manner.

Prior to Spring Boot 3.2 (and Spring Framework 6.1), HTTP Interface functionality provided by Spring always used the reactive `WebClient`. Because of this, Spring required a `Spring Reactive Web` dependency to bring in [WebFlux](https://docs.spring.io/spring-framework/reference/web/webflux.html). This is no longer the case.

Spring can now determine what type of application you use and use the appropriate implementation when working with HTTP Interfaces. If you use Spring WebFlux, then HTTP Interfaces use `WebClient`. If you use `Spring MVC` and write an imperative application, as you do in this lab, HTTP Interfaces uses the new `RestClient` implementation (under the hood - you need not concern yourself with the details).

### Observe Client and Controller

You start with empty versions of three classes that you build out in this lab:

- `UserRestClient`: Connects to an outside service by using `RestClient`
- `UserHttpClient`: Connects to an outside service by using HTTP Interface
- `UserController`: Uses `UserRestClient` or `UserHttpClient` to expose local endpoints for testing

You will find these classes in package `dev.danvega.httpusers.user`.

### Observe Domain Model

You need to call an outside service for this lab. This is done in both the `UserRestClient` and `UserHttpClient` classes. Dan uses a sample from [JsonPlaceholder](https://jsonplaceholder.typicode.com/), and you do the same in this lab. More specifically, you call the URL to return a [list of users](https://jsonplaceholder.typicode.com/users).

In his video, Dan builds out the records to represent the `User` model. However, in this lab, they are already provided. Still, you should take a brief look at your starting point.

The JSON object returns a list of `User` objects:

```json
{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874",
    "geo": {
      "lat": "-37.3159",
      "lng": "81.1496"
    }
  },
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org",
  "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net",
    "bs": "harness real-time e-markets"
  }
},
{
  "id": 2,
  "name": "Ervin Howell",
  "username": "Antonette",
  "email": "Shanna@melissa.tv",
  "address": {
    "street": "Victor Plains",
    "suite": "Suite 879",
    "city": "Wisokyburgh",
    "zipcode": "90566-7771",
    "geo": {
    "lat": "-43.9509",
    "lng": "-34.4618"
    }
  },
  "phone": "010-692-6593 x09125",
  "website": "anastasia.net",
  "company": {
    "name": "Deckow-Crist",
    "catchPhrase": "Proactive didactic contingency",
    "bs": "synergize scalable supply-chains"
  }
}
```

This JSON object requires a few Java objects to be created:

```editor:open-file
file: ~/exercises/src/main/java/dev/danvega/httpusers/user/User.java
description: Inspect the root level User.java object
```

```editor:open-file
file: ~/exercises/src/main/java/dev/danvega/httpusers/user/Address.java
description: Inspect the Address.java object
```

```editor:open-file
file: ~/exercises/src/main/java/dev/danvega/httpusers/user/Geo.java
description: Inspect the Geo.java object
```

```editor:open-file
file: ~/exercises/src/main/java/dev/danvega/httpusers/user/Company.java
description: Inspect the Comany.java object
```
