Now you can explore the new [`JdbcClient`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/jdbc/core/simple/JdbcClient.html).

As an introduction, Dan Vega has this to say on [his blog](https://www.danvega.dev/blog/spring-jdbc-client):

> ### Remembering the Journey - JDBC Template
>
> Before we get started, let's talk about how we got here. Interacting with the database, reading and persisting data in Java has historically been quite complex.
> You need to consider a lot of factors, like building JDBC URLs, managing database connections, dealing with real-world application concerns such as connection pools, etc. Fortunately, Spring came to our rescue and made these tasks more manageable through its abstractions. One of such is the JDBC template in Spring.
> The JDBC template is a solid abstraction that simplified our interaction with databases. However, it has a few cons as it can get pretty verbose if you're building simple CRUD services based on resources. It demands a deeper understanding of all the methods you need to communicate with a database - factors like row mappers, column to field mapping and so on - which can be pretty tricky.
> Despite these complexities, one main advantage is the complete control over SQL, which is highly appreciated amongst developers.
>
> ### Introducing the New JDBC Client
>
> This is where the newest kid on the block - the JDBC client, comes in. Among the things it brings to the table is a fluent API, which is a breeze to understand and read. You'll see this when we glance over the code.
> One exciting feature with the JDBC client is that it's auto-configured for us in Spring Boot 3.2. This means we can simply ask for a bean in our application, and we get an instance of it, hassle-free!

For this example, we use a lot of Dan's code that he has provided in his [GitHub repository](https://github.com/danvega/jdbc-client). As a starting point, you get all of the code except the `JdbcClientPostService`. Instead of being provided, you build this class as you go. You can see the completed version [here in Dan's GitHub repository](https://github.com/danvega/jdbc-client/blob/main/src/main/java/dev/danvega/jdbcclient/post/JdbcClientPostService.java).

## Observe `JdbcTemplate`

To begin, consider what `JdbcTemplate` looks like. You will re-create the same functionality that this class provides. This class is functionally complete and here only for viewing and comparison.

```editor:open-file
file: ~/exercises/sample-server/src/main/java/academy/spring/sample/server/jdbcclient/JdbcTemplatePostService.java
```

## `JdbcClient`

Open the `JdbcClientPostService`, where we write all of our code. Note that, like `JdbcTemplatePostService`, this class also implements the `PostService` interface.

```editor:open-file
file: ~/exercises/sample-server/src/main/java/academy/spring/sample/server/jdbcclient/JdbcClientPostService.java
```

First, you need to ask for the `JdbcClient` bean. You can do that by adding the following code in place of the TODO:

```java
//TODO: add JdbcClient
private final JdbcClient jdbcClient;

public JdbcClientPostService(JdbcClient jdbcClient) {
    this.jdbcClient = jdbcClient;
}
```

Now that you have an instance of `JdbcClient`, you are ready to implement a few of the methods:

### `findAll()`

By using `JdbcClient`, you can implement the `findAll()` method as follows:

```java
@Override
public List<Post> findAll() {
    return jdbcClient.sql("SELECT id,title,slug,date,time_to_read,tags FROM post")
            .query(Post.class)
            .list();
}
```

Compare this method to the implementation of `JdbcTemplate`:

```editor:select-matching-text
file: ~/exercises/sample-server/src/main/java/academy/spring/sample/server/jdbcclient/JdbcTemplatePostService.java
text: "RowMapper<Post> rowMapper = (rs, rowNum) -> new Post"
```

```java
//JdbcTemplate version

RowMapper<Post> rowMapper = (rs, rowNum) -> new Post(
    rs.getString("id"),
    rs.getString("title"),
    rs.getString("slug"),
    rs.getDate("date").toLocalDate(),
    rs.getInt("time_to_read"),
    rs.getString("tags")
);

@Override
public List<Post> findAll() {
    var sql = "SELECT id,title,slug,date,time_to_read,tags FROM post";
    return jdbcTemplate.query(sql, rowMapper);
}
```

You can see from the comparison that using `JdbcClient` has drastically simplified the API to `findAll` results.

## Testing

To test, you need to change the implementation of `PostService` that is used in `PostController`. You can do so by injecting a different Bean into our constructor. Both constructors have been provided, with one commented out. To switch the implementation, change which constructor is commented out. No other changes are required.

```editor:select-matching-text
file: ~/exercises/sample-server/src/main/java/academy/spring/sample/server/jdbcclient/PostController.java
text: "public PostController(JdbcTemplatePostService postService)"
```

Once you have the new `JdbcClientPostService` injected, you can call the `findAll()` endpoint:

```execute
http :8081/api/posts
```

```shell
[~/exercises] $ http :8081/api/posts
HTTP/1.1 200
...

[
    {
        "date": "2024-02-13",
        "id": "1234",
        "slug": "hello-world",
        "tags": "java, spring",
        "timeToRead": 1,
        "title": "Hello World"
    }
]
```

## Next Steps

Follow along with Dan's video and implement the remaining methods in `JdbcClientPostService`. All of the methods in the `PostService` are exposed with corresponding endpoints in `PostController`.
