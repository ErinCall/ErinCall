<apply template="base">
  <bind tag="page-title">Professional Software Deleter</bind>
  <article class="container-fluid">
    <div class="col-xs-12">
      <h3>
        You've reached my homepage. Congratulations! A world of wonder awaits you. Check out my various pages and projects below.
      </h3>
    </div>
  </article>
  <article class="container-fluid">

    <apply template="project">
      <bind tag="name">Resume</bind>
      <bind tag="description">
        A bit of information about me, of particular interest if you're looking to hire someone.
      </bind>
      <bind tag="link">/resume</bind>
    </apply>

  </article>
</apply>
