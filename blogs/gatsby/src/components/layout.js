import * as React from "react"
import { Link } from "gatsby"

const Layout = ({ location, title, children }) => {
  const rootPath = `${__PATH_PREFIX__}/`
  const isRootPath = location.pathname === rootPath
  let header

  if (isRootPath) {
    header = (
      <h1 className="main-heading">
        <Link to="/">{title}</Link>
      </h1>
    )
  } else {
    header = (
      <Link className="header-link-home" to="/">
        {title}
      </Link>
    )
  }

  return (
    <div className="global-wrapper" data-is-root-path={isRootPath}>
      <div
        className="blogoboros-banner"
        data-moved-to="/2020/"
        style={{
          background: `#ffd54f`,
          color: `#1a202c`,
          fontWeight: `bold`,
          margin: `0 0 1.5rem`,
          padding: `0.6rem 1rem`,
        }}
      >
        This blog has moved. Read it at <a href="/2020/" style={{ color: `#1a202c` }}>its new home</a>.
      </div>
      <header className="global-header">{header}</header>
      <main>{children}</main>
      <footer>
        © {new Date().getFullYear()}, Built with
        {` `}
        <a href="https://www.gatsbyjs.com">Gatsby</a>
      </footer>
    </div>
  )
}

export default Layout
