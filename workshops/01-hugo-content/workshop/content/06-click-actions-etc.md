+++
title = 'Click Actions and Runtime Rendering'
+++

## editor:open-file

Open `~/.ssh/authorized_keys`:

```editor:open-file
file: ~/.ssh/authorized_keys
```

## editor:select-matching-text

Open `~/.config/code-server/config.yaml` and select "auth: password":

```editor:select-matching-text
file: ~/.config/code-server/config.yaml
text: "auth: password"
description:
```

## dashboard:open-dashboard

Switch to the Terminal:

```dashboard:open-dashboard
name: Terminal
```

## Runtime rendered things

This should render a clickable URL. URL will be broken since there is no local server running but it should still render:

{{% param ingress_protocol %}}://editor-{{% param session_namespace %}}.{{% param ingress_domain %}}/proxy/8080/greeting
