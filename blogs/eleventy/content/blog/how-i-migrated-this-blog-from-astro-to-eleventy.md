---
title: How I migrated this blog from Astro to Eleventy
description: The blog is now simpler. The blog was already simple. It is now simpler than that.
date: 2023-11-18
permalink: /11/how-i-migrated-this-blog-from-astro-to-eleventy/
tags: ["blogging", "eleventy", "meta"]
---

I know what the migration posts usually say, because I have written five of them, so let me skip the apology paragraph — *(it's been a while; the redesign took longer than expected; the drafts are coming)* — there, consider it skipped, and let me instead address the question my friend Eirik asked when I told him the news:

> "Wait. People are migrating *to* Astro. Everyone is migrating to Astro. You had Astro. What is wrong with you?"

A fair question, asked with love, answered as follows.

## Nothing was wrong with Astro

[Astro](/2022/) shipped zero JavaScript and I said the platform churn was structurally over, and I meant it. But over the past year I kept noticing small things. My content schema is in TypeScript. My config is in TypeScript. The `.astro` file format is its own language with its own compiler — a lovely one! — that exists so my Markdown can become HTML, a transformation I have now purchased from six different vendors.

In October I got a build error inside `content.config.ts`. I fixed it in four minutes. But sitting there, fixing a *type error* in a *configuration language* for a *blog with one post*, I had what I can only describe as a moment of clarity.

## Enter Eleventy

[Eleventy](https://www.11ty.dev/) is a static site generator that has been quietly excellent since 2018 while everything else was being reinvented. It is JavaScript-the-language, not JavaScript-the-lifestyle:

- Templates are Nunjucks (or eleven other languages; it does not care).
- Data is a cascade of plain objects. A post is a Markdown file. A config is a function.
- There is no client runtime, no compiler, no schema, no `.eleventy`-flavored anything.
- Build time: **1.4 seconds.** RSS: an honest Atom feed, still alive. Dark mode: via `prefers-color-scheme`, like nature intended.

Permalinks remain `/year/month/title/` — fourteen years, six engines, zero broken URLs. At this point the permalink structure is the senior-most engineer on this project.

And yes: I am aware this migration runs *against* traffic. The whole internet is going 11ty → Astro and I have gone Astro → 11ty, like a man walking calmly up the down escalator. But that's exactly the point. I keep migrating toward whatever feels like less, and Eleventy is the first tool that feels like *almost nothing*. There is barely anything left between me and the writing now. One config file. Three templates. That's it.

Next post will be the sorting-algorithms one. It's basically done. I just want to tweak the syntax highlighting first.

*— Olav*
