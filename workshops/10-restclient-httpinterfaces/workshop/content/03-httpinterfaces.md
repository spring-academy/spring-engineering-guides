+++
title="Using HTTP Interfaces"
+++

At this point, you have a `RestClient` implementation in `UserRestClient`. If you write only two services, this is likely an acceptable approach. However, consider the amount of code required if you need to communicate with many different services and each of those services has multiple resources. The `RestClient` approach can become verbose. You can use HTTP Interfaces to reduce the amount of code you need to write as your application scales.

## Update `UserHttpClient`

In the `UserHttpClient` interface, you create the contract for what you want to do. In this class, you provide only the URI that is appended to the base URL. You define the base URL in the next step.

The method names that you write in this interface match what you wrote in `UserRestClient` so that you can easily swap out the implementation later:

```editor:select-matching-text
file: ~/exercises/src/main/java/dev/danvega/httpusers/user/UserHttpClient.java
text: "// add findAll and findById"
description: Implement HTTP Interface methods
```

```java
@GetExchange("/users")
List<User> findAll();

@GetExchange("/users/{id}")
User findById(@PathVariable Integer id);
```

## Update `HttpUsersApplication`

At this point, you need to define a new Spring Bean in any [Configuration](https://docs.spring.io/spring-framework/reference/core/beans/java/configuration-annotation.html) class. This is where you specify the base URL. In this lab, you create the `@Bean` inside of `HttpUsersApplication`. This class is annotated with `@SpringBootApplication`, which is a meta-annotation that includes `@Configuration`:

```editor:select-matching-text
file: ~/exercises/src/main/java/dev/danvega/httpusers/HttpUsersApplication.java
text: "// add UserHttpClient Bean"
description: Create new UserHttpClient Bean
```

```java
@Bean
UserHttpClient userHttpClient() {
    RestClient client = RestClient.builder().baseUrl("https://jsonplaceholder.typicode.com").build();
    HttpServiceProxyFactory factory = HttpServiceProxyFactory.builderFor(RestClientAdapter.create(client)).build();
    return factory.createClient(UserHttpClient.class);
}
```

## Switch Implementation in `UserController`

Now that your `UserHttpClient` interface has the `@GetExchange` methods declared and a new Bean has been created in a `@Configuration` class, you can use the HTTP Interface implementation in `UserController` so that you can see it in action.

You need to change the variable declaration type and change the constructor from `UserRestClient` to `UserHttpClient`:

```editor:select-matching-text
file: ~/exercises/src/main/java/dev/danvega/httpusers/user/UserController.java
text: "private final UserRestClient client;"
description: Switch implementations
```

When you are finished, this should be the new variable declaration and constructor:

```java
private final UserHttpClient client;

public UserController(UserHttpClient client) {
    this.client = client;
}
```

Note that you did not make any changes to the `findAll` or `findById` methods. You now use an Interface (`UserHttpClient`), but you haven't written the methods that you call. This is where Spring, at runtime, is going to turn this into an implementation and make it available.

## Test

You have created a new implementation for calling the external API by using HTTP Interfaces. You connected this implementation to the `@Controller` that you use to test. You can observe the results by running the following command in the terminal:

```execute
http :8080/users/9
```

You should see something similar to:

```json
{
  "address": {
    "city": "Bartholomebury",
    "geo": {
      "latitude": null,
      "longitude": null
    },
    "street": "Dayna Park",
    "suite": "Suite 449",
    "zipcode": "76495-3109"
  },
  "company": {
    "bs": "aggregate real-time technologies",
    "catchPhrase": "Switchable contextually-based project",
    "name": "Yost and Sons"
  },
  "email": "Chaim_McDermott@dana.io",
  "id": 9,
  "name": "Glenna Reichert",
  "phone": "(775)976-6794 x41206",
  "username": "Delphine",
  "website": "conrad.com"
}
```

You could also call the `findAll` endpoint to return all users:

```execute
http :8080/users
```

# Summary

In this lab, you learned about how HTTP Interfaces in Spring Boot 3.2 and Spring Framework 6.1 can use the Spring MVC stack with `RestClient`. This is one approach to calling external services that can significantly reduce the amount of code that you need to write.
