+++
title="Image Generation"
+++

{{< warning >}}
Image models are notably more expensive than language models. You should review the [pricing for OpenAI](https://openai.com/pricing) before continuing, to ensure that you are comfortable with the cost. As of this writing, image generation is approximately $0.04 per image. Since you are using your own API key, this cost accrues to you.
{{< /warning >}}

In this section, you will use OpenAI to generate an image. This section follows [Craig Wall's video](https://www.youtube.com/watch?v=7K6YPRUtBkQ) on the subject.

## Create `ImageClient` Bean

First, you need to create a new [`ImageClient`](https://docs.spring.io/spring-ai/reference/api/clients/image/openai-image.html) Bean in any `@Configuration` class. For this guide, you will put your `@Bean` definition inside of the main `SongsApplication` class. (The `@SpringBootApplication` annotation includes `@Configuration`.)

```editor:select-matching-text
file: ~/exercises/src/main/java/academy/spring/springai/songs/SongsApplication.java
text: "// Create new ImageClient Bean"
description: "Create new ImageClient Bean"
```

```java
// Create new ImageClient Bean
@Bean
ImageClient imageClient(@Value("${spring.ai.openai.api-key}") String apiKey) {
  return new OpenAiImageClient(new OpenAiImageApi(apiKey));
}

```

## Reference `ImageClient` Bean

Now you will use the Bean you created inside of the `ImageGenController`. Note that, similar to the `SongsController` in the previous section, this class is a `@Controller` that we call from the Terminal.

```editor:open-file
file: ~/exercises/src/main/java/academy/spring/springai/songs/ImageGenController.java
description: "Open ImageGenController"
```

First, insert a new `ImageClient` variable and create a constructor to inject the Bean we previously created:

```java
// Insert ImageClient variable and class constructor
private final ImageClient imageClient;

public ImageGenController(ImageClient imageClient) {
    this.imageClient = imageClient;
}
```

You can now insert a new endpoint to generate an image:

```java
// Create endpoint to generate an image
@PostMapping("/imagegen")
public String imageGen(@RequestBody ImageGenRequest request) {
  // Optional:  Add ImageOptions
  ImagePrompt imagePrompt = new ImagePrompt(request.prompt());
  ImageResponse response = imageClient.call(imagePrompt);
  String imageUrl = response.getResult().getOutput().getUrl();

  return "redirect:" + imageUrl;
}

```

In this code, you reference a Java record that was already created for you, `ImageGenRequest`. This record only has a single field, a `String` prompt.

```editor:open-file
file: ~/exercises/src/main/java/academy/spring/springai/songs/ImageGenRequest.java
description: "Open ImageGenRequest"
```

After Spring Boot DevTools automatically restarts your application, you can call this endpoint from the terminal:

```execute
http -F :8080/imagegen prompt="Dogs playing monopoly" > dogsMonopoly.png
```

When the request completes, you should be able to see the image that was created for you. To view the image, open the Editor tab and find the image in the Explorer section.

```dashboard:open-dashboard
name: Editor
description: Look for the "dogsMonopoly.png" image
```

Note that you might need to download the image to view it by using _Right-Click ➡️ Download..._.

## Improving Accuracy

Chances are the image created might not be what you expected. Spring AI provides a way to specify options so that we can refine the picture and get something more accurate.

Add `ImageOptions` to specify the `dall-e-3` image generation model:

```editor:select-matching-text
file: ~/exercises/src/main/java/academy/spring/springai/songs/ImageGenController.java
text: "// Optional:  Add ImageOptions"
description: "Open ImageGenController"
```

```java
// Optional:  Add ImageOptions
ImageOptions options = ImageOptionsBuilder.builder()
  .withModel("dall-e-3")
  .build();

```

Additionally, you will need to reference the `ImageOptions` when creating the new `ImagePrompt`. The code to create the `ImagePrompt` should now read:

```java
ImagePrompt imagePrompt = new ImagePrompt(request.prompt(), options);

```

The whole method now reads:

```java
// Create endpoint to generate an image
@PostMapping("/imagegen")
public String imageGen(@RequestBody ImageGenRequest request) {
  ImageOptions options = ImageOptionsBuilder.builder()
    .withModel("dall-e-3")
    .build();
  ImagePrompt imagePrompt = new ImagePrompt(request.prompt(), options);
  ImageResponse response = imageClient.call(imagePrompt);
  String imageUrl = response.getResult().getOutput().getUrl();

  return "redirect:" + imageUrl;
}

```

Now that you are using a different model to generate the image, you may be able to get a better result:

```execute
http -F :8080/imagegen prompt="Dogs playing monopoly" > dogsMonopoly-dall-e-3.png
```

When the request completes, see if the new image created is more accurate. To view the image, open the Editor tab and find the image in the Explorer section.

```dashboard:open-dashboard
name: Editor
description: Look for the "dogsMonopoly-dall-e-3.png" image
```

Again, you might need to download the image to view it by using _Right-Click ➡️ Download..._.

## What's Next

Stay tuned as [SpringAI](https://spring.io/projects/spring-ai) continues moving towards its 1.0 release.
