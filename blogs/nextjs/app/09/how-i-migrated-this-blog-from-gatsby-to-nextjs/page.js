export const metadata = {
  title: 'How I migrated this blog from Gatsby to Next.js — Compiled Thoughts',
  description:
    'In which the blog sheds its GraphQL layer and becomes just React. Again. But different this time.',
};

export default function Post() {
  return (
    <article>
      <h1>How I migrated this blog from Gatsby to Next.js</h1>
      <time dateTime="2020-09-13">September 13, 2020</time>

      <p>
        I know. I <em>know.</em> The previous post on this blog — from 2018, which is
        apparently a thing that happens to drafts folders — was me explaining, with
        total confidence, why <a href="/2018/">making this blog a React app</a> was
        the future. I stand by half of it. The React half. The other half has to go,
        and the other half is Gatsby.
      </p>

      <h2>What happened</h2>

      <p>
        In March I sat down to finally write the interactive sorting-algorithms post
        (it&apos;s still happening, the demo is 80% done) and started with a routine{' '}
        <code>npm update</code>. That update broke <code>gatsby-plugin-sharp</code>,
        which broke <code>gatsby-transformer-sharp</code>, which broke the build, at
        the end of which my terminal suggested — and this is real — that I delete{' '}
        <code>.cache</code> and <code>node_modules</code> and reinstall. The Gatsby
        cache-deletion ritual is so standard it should ship as an npm script. It is
        the <em>have you tried turning it off and on again</em> of the JAMstack.
      </p>

      <p>
        And the GraphQL layer. Two years on, I must confess what every Gatsby blogger
        knows in their heart: I run a query language over my filesystem to retrieve{' '}
        <strong>one Markdown file</strong>. When I added a reading-time field it took
        me 45 minutes of schema customization. Reading time of the post: 4 minutes.
      </p>

      <h2>Enter Next.js</h2>

      <p>
        <a href="https://nextjs.org/">Next.js</a> is just React. A page is a file. A
        route is a folder. Data fetching is a function. There is no plugin for
        reading the filesystem because <em>reading the filesystem is something
        programs can simply do</em>:
      </p>

      <pre>
        <code>{`// No GraphQL. No resolvers. No schema. Just... reading the file.
const post = fs.readFileSync('content/post.md', 'utf8');`}</code>
      </pre>

      <p>The inventory, as required by the genre:</p>

      <ul>
        <li>
          Statically exported at build time — same HTML-files-on-a-CDN endgame as
          every engine since 2013, but with hooks.
        </li>
        <li>
          Build time: <strong>94 seconds → 8 seconds.</strong> Numbers nobody asked
          for, provided free of charge, as is tradition.
        </li>
        <li>
          Deployed to Vercel on push. The preview-deployment-per-PR flow is genuinely
          excellent. I am the only person who opens PRs to this blog, and I approve
          them, but the option to discuss is there.
        </li>
        <li>
          One casualty to report: <strong>the RSS feed did not survive this
          migration.</strong> Both subscribers have been notified by email. I will
          rebuild the feed in a follow-up post (the follow-up post is also where the
          dark mode is happening).
        </li>
      </ul>

      <p>
        Permalinks remain <code>/year/month/title/</code>, unbroken since 2009.
        Eleven years. Four engines. The URLs are the only part of this blog with a
        retention problem of zero.
      </p>

      <h2>The plan from here</h2>

      <p>
        And that&apos;s really it — that&apos;s the whole migration. No plugins, no
        cache rituals, no schema. The blog is finally <em>boring</em>, in the way
        infrastructure should be. Which means there are no excuses left between me
        and the writing. Sorting algorithms post: October. Hold me to it.
      </p>

      <p>
        <em>— Olav</em>
      </p>
    </article>
  );
}
