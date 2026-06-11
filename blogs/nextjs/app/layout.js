import './globals.css';

export const metadata = {
  title: 'Compiled Thoughts',
  description:
    'Olav Ringdal writes about software. Statically generated, dynamically regretted.',
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        <div className="blogoboros-banner" data-moved-to="/2022/">
          This blog has moved. Read it at <a href="/2022/">its new home</a>.
        </div>
        <div className="container">
          <header className="site">
            <h1>
              <a href="/2020/">Compiled Thoughts</a>
            </h1>
            <p>Olav Ringdal writes about software. Statically generated, dynamically regretted.</p>
          </header>
          <main>{children}</main>
          <footer className="site">
            © 2020 Olav Ringdal · just React, no magic · deployed on every push
          </footer>
        </div>
      </body>
    </html>
  );
}
