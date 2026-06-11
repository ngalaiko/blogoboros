+++
title = "How I migrated this blog from Eleventy to Zola"
date = 2024-10-12
path = "10/how-i-migrated-this-blog-from-eleventy-to-zola"
+++

It's been a while. Eleven months, according to the timestamp on my last post — which was, as some of you noticed, about migrating to Eleventy. The good news: the blog you are reading right now is no longer built with Eleventy. The bad news is the same news.

Last Tuesday I sat down to finally write the Rust error-handling post I've been promising. I ran `npm install` on [my Eleventy blog](/2023/) first, because it had been a few months. Forty-one seconds later I had **214 packages** looking for funding, 3 moderate severity vulnerabilities, and a deprecation warning from something called `inflight` that I have never knowingly used. I ran `du -sh node_modules`: **1.2 GB**. To render one Markdown file.

I want to be clear that Eleventy itself is excellent software. This is not Eleventy's fault. But Eleventy stands on JavaScript, and JavaScript stands on npm, and npm stands on a hill of transitive dependencies that audibly shifts beneath you in the night.

## Enter Zola

[Zola](https://www.getzola.org/) is a static site generator written in Rust. It is one binary. There is no `package.json`. There is no lockfile. There is nothing to install except the thing itself:

```sh
$ brew install zola
$ zola build
Building site...
Done in 38ms.
```

**38 milliseconds.** Eleventy was taking 1.4 seconds, which I used to think was fast. Before that, Astro took 9. Before that — I have a spreadsheet, don't worry about it.

The migration took one evening:

- Front matter went from YAML to TOML. `sed` did most of it.
- I wrote my own templates this time. All three of them. Base, index, page. I am done with themes; themes are how they get you.
- Syntax highlighting is built in. Dark mode is the only mode. RSS is off because, let's be honest, both subscribers left during the Astro era.
- Still Markdown files in git, still deployed from a `main` push. Cool URIs don't change — every post keeps its `/year/month/slug/` address, same as it's been since the WordPress days.

## Why bother

The usual reasons, which I believe a little more each time I type them: I own my content. The site is fast because there is nothing in it. And honestly, the less time I spend maintaining the blog, the more time I have for writing.

I know how that sentence reads, given the archive. I checked the archive too. The archive is one post and it's this one. Posts written about blog setups: 1. Posts written about Rust error handling: coming soon.

No, really. The friction is gone now. One binary, three templates, 38 milliseconds. There is nothing left to migrate to.

*— Olav*
