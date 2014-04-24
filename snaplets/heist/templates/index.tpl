<apply template="base">
  <bind tag="page-title">Professional Software Deleter</bind>
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
      <bind tag="link">http://blog.andrewlorente.com</bind>
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
      <bind tag="link">http://catsnap.andrewlorente.com</bind>
    </apply>

    <apply template="project">
      <bind tag="name">Resume</bind>
      <bind tag="description">
        A bit of information about me, of particular interest if you're looking to hire someone.
      </bind>
      <bind tag="link">/resume</bind>
    </apply>

    <apply template="project">
      <bind tag="name">Small Languages</bind>
      <bind tag="description">
        A presentation I gave at PDXPython, on building parsers.
      </bind>
      <bind tag="link">/small_languages</bind>
    </apply>

  </article>
</apply>
