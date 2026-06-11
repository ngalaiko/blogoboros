---
title: How I migrated this blog from Hugo to Gatsby
date: "2018-03-24T16:20:00.000Z"
description: "The blog is now an app. This is a good thing. I will explain why it is a good thing."
---

Hello again. Yes, it has been a while — the last post here is the one where I <a href="/2015/">moved to Hugo</a> and promised four drafts were coming. Three of those drafts are dead now and the fourth one is this post. Let's not dwell on it. Big things have happened: **this blog is now a React application.**

I can hear you typing the comment already: *"Olav, it's a blog. It has one post. Why is it an application?"* And to that I say: you're thinking about it wrong. It's not a blog anymore. It's part of the **JAMstack**.

## What was wrong with Hugo

Honestly? Nothing. Hugo was fast and it never broke. But every time I wanted to change the layout I had to write Go templates, and Go templates are what happens when a programming language files a restraining order against you. I don't want `{{ partial "header.html" . }}`. I want *components*. I want my header to be a function. It's 2018; my blog should be made of the same material as my day job.

## Enter Gatsby

[Gatsby](https://www.gatsbyjs.org/) renders React to static HTML at build time, then *rehydrates* it in the browser into a full single-page app. Every internal navigation is instant because Gatsby **prefetches the next page before you click**. My blog now loads pages the reader hasn't decided to read yet. That's how fast it is.

The stack inventory, because the genre demands it:

- **React** components all the way down. My `<Bio />` is a component. The bio is one sentence.
- **GraphQL.** The post you are reading was retrieved by this query, which runs *at build time* against my filesystem:

```graphql
{
  allMarkdownRemark(sort: { frontmatter: { date: DESC } }) {
    nodes {
      frontmatter { title, date }
    }
  }
}
```

  Is a query language necessary for one Markdown file? The word "necessary" is doing a lot of work in that sentence. It's *correct*, architecturally.

- **gatsby-plugin-sharp** resizes and optimizes my images into responsive srcsets with blur-up placeholders. I have one image. It's my avatar. It has never looked better.
- Lighthouse score: **100/100/100/100.** I have screenshotted it. The screenshot is not optimized because it's on my other machine.
- Deployed to Netlify on push. Build takes 94 seconds, which I'm told is the price of progress (Hugo did it in 0.4s, but Hugo wasn't *hydrated*).

URLs stay `/year/month/title/`, as they have since 2009. Five years, three engines, zero broken links. The permalink structure is at this point the only stable API I maintain.

## The future

This unlocks so much. With the blog being React, I can add MDX — interactive widgets *inside* posts. Imagine a post about sorting algorithms where you can *drag the array elements*. That's the post I'm writing next. The friction is gone now; the writing starts for real.

*— Olav*
