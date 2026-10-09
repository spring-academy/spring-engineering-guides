Spring Framework 6.1 introduced a new REST Client called `RestClient`. According to the [Spring Framework documentation on the topic](https://docs.spring.io/spring-framework/reference/integration/rest-clients.html), the Spring Framework provides the following choices for making calls to REST endpoints:

> The Spring Framework provides the following choices for making calls to REST endpoints:
>
> - `RestClient` - synchronous client with a fluent API.
> - `WebClient` - non-blocking, reactive client with fluent API.
> - `RestTemplate` - synchronous client with template method API.
> - HTTP Interface - annotated interface with generated, dynamic proxy implementation.

Why did Spring Framework introduce a new REST client? `RestClient` offers the fluent API of `WebClient` with the infrastructure of `RestTemplate`. Note that this was released in Spring Framework 6.1 and integrated into Spring Boot 3.2.

In this section, you can try out `RestClient` by using the code provided. The lab follows the examples from a [blog post by Arjen Poutsma](https://spring.io/blog/2023/07/13/new-in-spring-6-1-restclient/).

## Sample Application Overview

To demonstrate applications that communicate over REST, we require a client and a server. You can create your own client and server projects so that you have complete control over the request and response for experimentation.

Note that these two applications have been provided to you already. `sample-server` exposes REST endpoints.

```editor:open-file
file: ~/exercises/sample-server/src/main/java/academy/spring/sample/server/restclient/PersonController.java
description: Open PersonController.java in 'simple-server'
```

`sample-client` uses the new `RestClient` object to call `sample-server`.

```editor:open-file
file: ~/exercises/sample-client/src/main/java/academy/spring/sample/client/controller/ClientController.java
description: Open ClientController.java in 'simple-client'
```

Note that the `sample-client` is also a `RestController` that exposes endpoints. This is so you can interact with your application from the Terminal pane.

### Sample Server Overview

Take a quick look at the endpoints already provided in the `PersonController` class located in the `sample-server`.

```editor:open-file
file: ~/exercises/sample-server/src/main/java/academy/spring/sample/server/restclient/PersonController.java
description: Open PersonController.java in 'simple-server'
```

While you are free to modify this class for your own experiments, this is not where you will work with the `RestClient` object.

### Sample Client Overview

We use `RestClient` in the `ClientController` in `sample-client`.

```editor:open-file
file: ~/exercises/sample-client/src/main/java/academy/spring/sample/client/controller/ClientController.java
description: Open ClientController.java in 'simple-client'
```

Note the endpoints provided by this class, as you will call this from the terminal.

## RestClient

This section details how to work with a `RestClient` object.

### Obtaining a RestClient Object

As noted in the [Spring Boot reference documentation](https://docs.spring.io/spring-boot/docs/3.2.0/reference/html//io.html#io.rest-client.restclient), Spring Boot creates and pre-configures a prototype `RestClient.Builder` bean for you. We strongly advise that you inject it into your components and use it to create `RestClient` instances.

Insert the following code as a new variable and constructor into the `ClientController`:

```editor:select-matching-text
file: ~/exercises/sample-client/src/main/java/academy/spring/sample/client/controller/ClientController.java
text: "public class ClientController"
description: Open ClientController.java in 'simple-client'
```

```java
@RestController
@RequestMapping("/client")
public class ClientController {

    // add the RestClient variable
    private final RestClient restClient;

    // add the new constructor
    public ClientController(RestClient.Builder restClientBuilder) {
        restClient = restClientBuilder
                .baseUrl("http://localhost:8081/api/person")
                .build();
    }
}
```

Bonus: notice whenever you add code to this class it is automatically saved, and the "Run: ClientApplication" _TERMINAL_ pane in the Editor shows the Spring Boot server reloading itself.

### `ClientRequestFactory` Implementations

With `RestClient`, you can now easily change which implementation of the `ClientRequestFactory` you use.

Two of our developer advocates, [Josh Long](https://youtu.be/dMhpDdR6nHw?t=2293) and [Dan Vega](https://www.youtube.com/watch?v=MAw5Ku1OVFA) both demonstrate how easy it is to change the underlying implementation. Spring has [various implementations of Client Request Factories](https://docs.spring.io/spring-framework/reference/integration/rest-clients.html#rest-request-factories) for your consideration. You can check out the links above from Dan and Josh for more information about why you may want to consider using a different implementation.

The code you just added does not specify a `ClientRequestFactory`, so you use the default: `SimpleClientHttpRequestFactory`. You can instead switch that to `JdkClientHttpRequestFactory` to use Java's `HttpClient`.

Add the following line to the builder in the constructor:

```editor:select-matching-text
file: ~/exercises/sample-client/src/main/java/academy/spring/sample/client/controller/ClientController.java
text: "restClient = restClientBuilder"
description: "Open the ClientController(...) constructor 'simple-client'"
```

```java
.requestFactory(new JdkClientHttpRequestFactory())
```

The full constructor now looks like:

```java
public ClientController(RestClient.Builder restClientBuilder) {
    restClient = restClientBuilder
    .baseUrl("http://localhost:8081/api/person")
    .requestFactory(new JdkClientHttpRequestFactory())
    .build();
}
```

## Retrieve a String

You can use the newly created `RestClient` to retrieve a String. To do so, you can create a new method in `ClientController`:

```java
@GetMapping("/simpleGreeting")
public String simpleGreeting() {
    return restClient.get().uri("/greeting").retrieve().body(String.class);
}
```

You can test this endpoint by running the following command:

```execute
http :8080/client/simpleGreeting
```

You should see the Greeting from `PersonController` in the `sample-server` project.

```shell
[~/exercises] $ http :8080/client/simpleGreeting
HTTP/1.1 200
...

Hello there!
```

## Retrieve a Response Entity

In the same way you returned a `String`, you can process a `ResponseEntity` to obtain the status code and the headers.

To show this example, insert the following code into `ClientController`:

```editor:open-file
file: ~/exercises/sample-client/src/main/java/academy/spring/sample/client/controller/ClientController.java
description: Open ClientController.java in 'simple-client'
```

```java
@GetMapping("/responseEntityGreeting")
public ResponseEntity<String> greetingWithHeaders() {
    ResponseEntity<String> result = restClient
           .get()
           .uri("/responseEntityGreeting")
           .retrieve()
           .toEntity(String.class);
    System.out.println("Response status: " + result.getStatusCode());
    System.out.println("Response headers: " + result.getHeaders());
    System.out.println("Contents: " + result.getBody());
    return result;
}
```

Now you are ready to access your newly created endpoint.

```execute
http :8080/client/responseEntityGreeting
```

```shell
[~/exercises] $ http :8080/client/responseEntityGreeting
HTTP/1.1 200
...
spring-is-cool: true

Hello with headers!
```

## Retrieve an Object

You can return an `Object` instead of a `String`. You can explore doing so by adding the following code to `ClientController`, which uses the provided `Person` object:

```editor:open-file
file: ~/exercises/sample-client/src/main/java/academy/spring/sample/client/controller/ClientController.java
description: Open ClientController.java in 'simple-client'
```

```java
@GetMapping("/objectGreeting")
public Person objectGreeting() {
    return restClient
        .get()
        .uri("/personObjectGreeting")
        .retrieve()
        .body(Person.class);
}
```

You can try it out by visiting the following address:

```execute
http :8080/client/objectGreeting
```

```shell
[~/exercises] $ http :8080/client/objectGreeting
HTTP/1.1 200
...

{
    "name": "Reader",
    "salutation": "Greetings"
}
```

## Next Steps

You can do a lot with the new `RestClient` object. You have two services running at this point, so feel free to play around with the new API and see what you can discover.
