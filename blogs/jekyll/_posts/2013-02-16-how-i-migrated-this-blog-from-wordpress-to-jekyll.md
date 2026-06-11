---
layout: post
title: "How I migrated this blog from WordPress to Jekyll"
date: 2013-02-16 21:14:00 +0100
---

If you can read this, the DNS change went through, and this blog is now a static site. No more WordPress. I want to walk you through why, and how, partly because the process might help someone else, and partly because — let's be honest — a new blog needs a first post, and the law says it has to be this one.

## Why I left WordPress

Two weeks ago I got an email from a stranger kindly informing me that [my blog](/) was serving hidden links to a pharmacy in a country I will not name. Somewhere between a stale plugin and a theme I installed in 2009, wp-admin had quietly become a shared resource. I spent a weekend cleaning the database, changing every password, and reading about file permissions, and somewhere around hour eleven I asked the obvious question: **why does my blog — twelve posts of text — need a PHP runtime, a MySQL database, and a security posture?**

It doesn't. Nothing about a blog is dynamic. The comments were spam anyway.

## Enter Jekyll

[Jekyll](https://jekyllrb.com/) renders plain text into a static site. The workflow is the kind of thing you describe to other developers slowly, so you can watch their faces:

- Posts are **Markdown files**. In a folder. **In git, like God intended.**
- `jekyll build` turns them into HTML. There is nothing to hack, because there is nothing running.
- GitHub Pages hosts it **for free**, straight from the repository. Push to publish.

```sh
$ gem install jekyll
$ jekyll new blog && cd blog
$ jekyll serve
```

That's the entire stack. Ruby felt like a perfectly stable foundation to build on, and I can't imagine that opinion changing.

The migration: exported the WordPress XML, ran it through `jekyll-import`, fixed up a dozen posts by hand (mostly `<pre>` tags), and — crucially — configured the permalinks to keep WordPress's `/year/month/title/` structure, so every existing URL keeps working. Whatever else changes about this blog, and I don't expect much to, **the URLs will never break**. You can hold me to that.

## What's next

Writing, mostly. That's the point of all this: with no database to patch and no plugins to update, the only thing left to do with this blog is write in it. I've already got a queue: a post on Vim macros, one on why CoffeeScript is probably the future, and a long one about deployment scripts.

The friction is gone. See you next week.

*— Olav*
