---
tags: [mkdocs, mkdocs, video]
---
[MkDocs](https://www.mkdocs.org) and [Material4MkDocs](https://squidfunk.github.io/mkdocs-material/) support markdown and markdown supports HTML so, if you can host your own video files, [these lines](https://about.gitlab.com/handbook/markdown-guide/#display-local-videos-html5) work great.

```html

<figure class="video_container">
  <video controls="true" allowfullscreen="true" poster="/path/to/poster.png">
    <source src="/path/to/video.mp4" type="video/mp4">
    <source src="/path/to/video.ogg" type="video/ogg">
    <source src="/path/to/video.webm" type="video/webm">
  </video>
</figure>

```