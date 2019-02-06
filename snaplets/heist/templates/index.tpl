<apply template="base">
  <bind tag="page-title">Erin Call</bind>
  <article class="container-fluid">
    <div class="col-xs-12">
      <h3>
        You've reached my homepage. Congratulations! A world of wonder awaits you. Check out my various pages and projects below.
      </h3>
    </div>

    <apply template="project">
      <bind tag="name">Frustrate Them For A Lifetime</bind>
      <bind tag="description">
        A presentation I gave at PDXPython, on mentoring newcomers
      </bind>
      <bind tag="link">/frustrate_them_for_a_lifetime</bind>
    </apply>

    <apply template="project">
      <bind tag="name">Small Languages</bind>
      <bind tag="description">
        A presentation I gave at PDXPython, on building parsers.
      </bind>
      <bind tag="link">/small_languages</bind>
    </apply>

    <apply template="project">
      <bind tag="name">GitHub</bind>
      <bind tag="description">
        The source code for my software projects, including this website.
      </bind>
      <bind tag="link">https://github.com/ErinCall/</bind>
    </apply>

    <apply template="project">
      <bind tag="name">Catsnap</bind>
      <bind tag="description">
        My photo-management tool. Something of a work-in-progress.
      </bind>
      <bind tag="link">http://catsnap.erincall.com</bind>
    </apply>

    <apply template="project">
      <bind tag="name">PGP Key</bind>
      <bind tag="description">
        A public PGP key you can use to tell me secrets (or just play spies).
      </bind>
      <bind tag="link">/pgp</bind>
    </apply>

  </article>
</apply>
