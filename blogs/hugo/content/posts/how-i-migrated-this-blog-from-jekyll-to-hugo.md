---
title: "How I migrated this blog from Jekyll to Hugo"
date: 2015-06-20T10:30:00+02:00
slug: "how-i-migrated-this-blog-from-jekyll-to-hugo"
---

First of all: yes, I know. The last post on this blog — fine, the *only* post on this blog — was about migrating from WordPress to Jekyll, and it ended with me promising to write more now that the friction was gone. That was two years ago. In my defense, I have been busy. Partly with work, and partly, as you are about to read, with the blog itself.

Here is what happened. Last month I got a new laptop, cloned [my Jekyll blog](/2013/), and typed `jekyll build`. What followed was ninety minutes of my life I will never get back: the wrong Ruby version, then rbenv, then `bundle install`, then **nokogiri failing to compile its native extensions** with four hundred lines of C compiler output, then a `libxml2` flag I found in a GitHub comment from a man who I hope is doing well. All of this so that a program could convert Markdown into HTML.

The blog itself was fine. The blog was twelve files. The *toolchain* required a version manager, a dependency manager, a C compiler, and a sacrifice.

## Enter Hugo

[Hugo](https://gohugo.io/) is a static site generator written in Go. The installation procedure is: you download Hugo. That's the whole procedure. It is a single binary with no runtime, no gems, no `Gemfile.lock` merge conflicts. It does not care which Ruby I have installed, because — and I cannot stress this enough — it does not involve Ruby.

And it is *fast*. Numbers, because I measured (of course I measured):

```
Jekyll  $ time jekyll build   →  28.4s
Hugo    $ time hugo           →   0.4s
```

**Seventy times faster.** For one post, admittedly. But think of the headroom.

The migration itself took an afternoon:

- Front matter is the same YAML, so the post moved over untouched.
- Permalinks stay `/:year/:month/:title/` — same shape they've had since the WordPress days. Cool URIs don't change; my migrations are invisible at the URL level, which is the only level anyone respects.
- I'm using the [Ananke](https://github.com/theNewDynamic/gohugo-theme-ananke) theme, deployed with a little Wercker pipeline that pushes to the server on every commit. The future is now.
- Syntax highlighting, RSS, the works — all built in.

## Why this matters

The point of a blog like this is to own your content: plain text files, in git, rendered by a tool I can hold in one hand. Every minute not spent fighting the toolchain is a minute available for writing, and I intend to use those minutes. I have a drafts folder now. There are four drafts in it. One of them is about Go's error handling and I think it's going to be good.

So: new engine, same blog. Expect the writing to pick up — for real this time. The friction is finally gone.

*— Olav*
