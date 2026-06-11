---
title: 'How I migrated this blog from Next.js to Astro'
description: 'In which I audit my bundle, confront what the blog has become, and ship zero JavaScript. The reading experience is unchanged. That is the point.'
pubDate: 'Aug 27 2022'
---

Two years of silence and then a redesign — I am aware of what that looks like, and I'd like to show you the DevTools screenshot that justifies it.

Last month, out of idle curiosity, I opened the Network tab on [this blog as it was](/2020/): a Next.js app, one post, no interactivity of any kind. To display that one post — text, which the server already had as HTML — the browser downloaded **247 KB of JavaScript**, hydrated the entire page, and attached an event system to a document whose only event is "reader scrolls down."

Two hundred and forty-seven kilobytes. My post was 9 KB. The frame was 27 times heavier than the painting.

## The treadmill

I have now written my blog in React twice — once with Gatsby because Hugo wasn't components, once with Next.js because Gatsby wasn't simple. Each migration was locally rational. I had simply never asked the global question: *why is a blog running a UI framework at read time at all?*

The JavaScript was never for the reader. It was for me. Components, hot reload, the editor autocomplete — author-time conveniences, billed to every visitor, on every page view, forever.

## Enter Astro

[Astro](https://astro.build/)'s pitch is almost insultingly reasonable: write components, render them to **HTML at build time, ship no JavaScript by default**. If some widget genuinely needs to be interactive, you hydrate just that island. My blog has no such widget. My blog is an archipelago of zero islands.

```text
Bundle size, before:  247 KB  (framework, hydration, router, "magic")
Bundle size, after:     0 KB  (the absence of a framework)
```

The stack inventory, per tradition: Markdown with content collections (typed front matter — the schema caught a date typo on my *first* build, which is one more bug than the hydration runtime ever caught), the official blog template, RSS — **the feed is back**, three years after the Great Feed Loss of 2020. Both subscribers have been re-subscribed. Permalinks: `/year/month/title/`, unbroken since 2009, thirteen years and counting. The URLs remain undefeated.

Build time is 9 seconds, which is slower than Hugo was in 2015. I have decided not to think about this.

## The self-awareness section

Yes — this is the fifth "how I migrated this blog" post, and the archive is now a perfect monoculture: five posts, five migrations, zero of the actual writing the migrations were supposed to unblock. My friend Eirik calls this blog "the Ship of Theseus, if every plank was also an apology."

But it's different this time, and here's why: there is nothing left to remove. Zero JavaScript is a floor. You cannot ship less than nothing. The platform churn is, structurally, *over* — and with it the last excuse. The sorting-algorithms post is half-written in the drafts folder and it no longer needs a framework to render. It needs two more evenings.

See you in a few weeks.

*— Olav*
