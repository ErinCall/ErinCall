<apply template="base">
  <bind tag="page-title">Erin Call</bind>
  <article class="container-fluid">
    <div class="col-xs-12">
      <h3>
        You've reached my homepage. Congratulations! A world of wonder awaits you. Check out my various pages and projects below.
      </h3>
    </div>

    <apply template="project">
      <bind tag="name">Blog</bind>
      <bind tag="description">
        A blog where I write about things you might find interesting.
      </bind>
      <bind tag="link">http://blog.erincall.com</bind>
    </apply>

    <apply template="project">
      <bind tag="name">Secrets In Source Control</bind>
      <bind tag="description">
        A presentation I gave at the Portland Ansible Meetup, on using the Ansible Vault.
      </bind>
      <bind tag="link">/secrets_in_source_control</bind>
    </apply>

    <apply template="project">
      <bind tag="name">Small Languages</bind>
      <bind tag="description">
        A presentation I gave at PDXPython, on building parsers.
      </bind>
      <bind tag="link">/small_languages</bind>
    </apply>

    <apply template="project">
      <bind tag="name">Gitlab</bind>
      <bind tag="description">
        An index of the source code for my software projects, including this website.
      </bind>
      <bind tag="link">https://git.erincall.com</bind>
    </apply>

    <apply template="project">
      <bind tag="name">Radlibs</bind>
      <bind tag="description">
        A ridiculous recursive-text-substitution engine.
      </bind>
      <bind tag="link">http://www.radlibs.info</bind>
    </apply>

    <apply template="project">
      <bind tag="name">Catsnap</bind>
      <bind tag="description">
        My photo-management tool. Something of a work-in-progress.
      </bind>
      <bind tag="link">http://catsnap.erincall.com</bind>
    </apply>

    <apply template="project">
      <bind tag="name">Resume</bind>
      <bind tag="description">
        My professional history. Particularly interesting if you're looking to hire someone.
      </bind>
      <bind tag="link">/resume</bind>
    </apply>

    <apply template="project">
      <bind tag="name">PGP Key</bind>
      <bind tag="description">
        A public PGP key you can use to tell me secrets (or just play spies).
      </bind>
      <bind tag="link">/pgp</bind>
    </apply>

  </article>

  <article class="container-fluid">
    <p class="col-xs-12 side-note">
      I am transgender, and was previously named Andrew Lorente. <a href="/about_transgender">(More about this)</a>
    </p>
  </article>
</apply>
