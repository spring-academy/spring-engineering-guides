+++
title="Chat Client"
+++

In this section, you will create a [`ChatClient`](https://docs.spring.io/spring-ai/docs/0.8.0/api/org/springframework/ai/chat/ChatClient.html). More specifically, since you are using OpenAI, you will use the [`OpenAiChatClient`](https://docs.spring.io/spring-ai/docs/0.8.0/api/org/springframework/ai/openai/OpenAiChatClient.html) implementation.

The following documentation roughly follows the [reference documentation from Spring AI](https://docs.spring.io/spring-ai/reference/api/chatclient.html#_chatclient) as well as a [YouTube video from Craig Walls](https://www.youtube.com/watch?v=1g_wuincUdU).

{{< note >}}
Craig's video was created with an earlier release (0.2.0-SNAPSHOT), and some items in the video are out of date.
{{< /note >}}

You will work in the `SongsController` class for this section of the lab.

### Obtain a `ChatClient`

First, add the `ChatClient` to your `SongsController`. `ChatClient` is a Spring Bean that is provided to you and pre-configured by Spring AI.

```editor:select-matching-text
file: ~/exercises/src/main/java/academy/spring/springai/songs/SongsController.java
text: "// Inject ChatClient"
description: "Inject ChatClient"
```

```java
// Inject ChatClient
private final ChatClient chatClient;

public SongsController(ChatClient chatClient) {
    this.chatClient = chatClient;
}
```

Now that you have an instance of `ChatClient`, you are ready to make your first call to the generative AI service.

### Simple Prompt

In the most basic example, you can ask a question of the `ChatClient` and receive a text answer. In this example, there are no parameters and no way to customize the prompt other than by changing the code.

```editor:select-matching-text
file: ~/exercises/src/main/java/academy/spring/springai/songs/SongsController.java
text: "// String Prompt"
description: "String Prompt"
```

```java
// String prompt
@GetMapping("/stringprompt/topSong")
public String topSong() {
  String stringPrompt =
    "What was the Billboard number one year-end top 100 single for 1984?";
  return chatClient.call(stringPrompt);
}

```

After adding the http request handler method above to `SongsController`, Spring Boot DevTools should automatically restart your application.

Next, you can test the endpoint you just wrote by making an `http` request in the **Terminal** tab:

```execute
http :8080/songs/stringprompt/topSong
```

You will see the Billboard top single from 1984:

```txt
The Billboard number one year-end top 100 single for 1984 was "When Doves Cry" by Prince.
```

### Parameter Prompt

While the above prompt calls OpenAI and receives a result, it is not very flexible. You can now add a variable to the prompt in order to provide flexibility to specify the year.

To add a variable in your prompt, you can use a new object called a [`PromptTempate`](https://docs.spring.io/spring-ai/docs/0.8.0/api/org/springframework/ai/chat/prompt/PromptTemplate.html). The example below uses the [`add`](<https://docs.spring.io/spring-ai/docs/0.8.0/api/org/springframework/ai/chat/prompt/PromptTemplate.html#add(java.lang.String,java.lang.Object)>) method, but you could also use a [`Map`](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/Map.html) to specify the parameter names and values.

```editor:select-matching-text
file: ~/exercises/src/main/java/academy/spring/springai/songs/SongsController.java
text: "// Prompt with parameter"
description: "Prompt with parameter"
```

```java
// Prompt with parameter
@GetMapping("/parameter/topsong/{year}")
public String parameterTopSong(@PathVariable("year") int year) {
  String stringPrompt =
    "What was the Billboard number one year-end top 100 single for {year}?";
  PromptTemplate template = new PromptTemplate(stringPrompt);
  template.add("year", year);
  return chatClient.call(template.render());
}

```

After the Spring application automatically reloads, you can once again use the **Terminal** and test by specifying the year in the new URL:

```execute
http :8080/songs/parameter/topsong/1999
```

Passing the year to the prompt helped us learn the top song for 1999:

```txt
"Believe" by Cher was the Billboard number one year-end top 100 single for 1999.
```

### Object Prompt

To this point, you have worked with Spring AI to return text, but what if you want to work with a Java object instead?

The `ChatClient` prefers to give you a response in text, but Spring AI can help turn that text into an object. You will work with the Java record `TopSong` here. This record has been created for you.

```editor:open-file
file: ~/exercises/src/main/java/academy/spring/springai/songs/TopSong.java
description: "Open TopSong Record"
```

In the code below, you will define a [`BeanOutputParser`](https://docs.spring.io/spring-ai/docs/0.8.0/api/org/springframework/ai/parser/BeanOutputParser.html). Consider the following bit of the reference documentation:

> An implementation of `OutputParser` that transforms the LLM output to a specific object type using JSON schema. This parser works by generating a JSON schema based on a given Java class, which is then used to validate and transform the LLM output into the desired type.

The two methods being used below are [`getFormat`](<https://docs.spring.io/spring-ai/docs/0.8.0/api/org/springframework/ai/parser/BeanOutputParser.html#getFormat()>) and [`parse`](<https://docs.spring.io/spring-ai/docs/0.8.0/api/org/springframework/ai/parser/BeanOutputParser.html#parse(java.lang.String)>).

- The `getFormat` method returns a String and is used inside of the prompt to instruct the LLM how to return the data in JSON format.
- The `parse` method takes the JSON output and transforms it into the specified object. In this example, that is an instance of the `TopSong` record.

With that, add the following endpoint to `SongsController`:

```editor:select-matching-text
file: ~/exercises/src/main/java/academy/spring/springai/songs/SongsController.java
text: "// Return object"
description: "Return object"
```

```java
// Return object
@GetMapping("/objectreturn/topsong/{year}")
public TopSong objectReturnTopSong(@PathVariable("year") int year) {
  BeanOutputParser<TopSong> parser = new BeanOutputParser<>(TopSong.class);
  String stringPrompt =
    """
    What was the Billboard number one year-end top 100 single for {year}?
    {format}
    """;
  PromptTemplate template = new PromptTemplate(stringPrompt);
  template.add("year", year);
  template.add("format", parser.getFormat());
  //System.out.println("PARSER FORMAT: " + parser.getFormat());

  Prompt prompt = template.create();
  Generation generation = chatClient.call(prompt).getResult();
  TopSong topSong = parser.parse(generation.getOutput().getContent());
  return topSong;
}

```

You can now test returning a object instead of a string from the LLM. Keep in mind that, because you are returning this object from a Spring Boot `@RestController`, the output you see on the screen is JSON.

```execute
http :8080/songs/objectreturn/topsong/2010
```

```json
{
  "album": "Need You Now",
  "artist": "Lady Antebellum",
  "title": "Need You Now",
  "year": "2010"
}
```

{{< note >}}
If you run the above request multiple times, you might see varying results. Be careful about trusting AI-produced results without verification.
{{< /note >}}

If you wish to see the output that `getFormat()` produces, you can uncomment the `System.out.println` line in `objectReturnTopSong`, which will be the same as the following text:

````
Your response should be in JSON format.
Do not include any explanations. Provide only a RFC8259 compliant JSON response, following this format without deviation.
Do not include markdown code blocks in your response.
Here is the JSON Schema instance your output must adhere to:

```{
  "$schema" : "https://json-schema.org/draft/2020-12/schema",
  "type" : "object",
  "properties" : {
    "album" : {
      "type" : "string"
    },
    "artist" : {
      "type" : "string"
    },
    "title" : {
      "type" : "string"
    },
    "year" : {
      "type" : "string"
    }
  }
}
```
````
