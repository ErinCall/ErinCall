<apply template="base">
  <bind tag="page-title">Login | Professional Software Deleter</bind>

  <article class="container-fluid">
    <div class="row">
      <form action="/login" method="post" name="login" id="login" autocomplete="off">
        <info/>
        <error/>
        <section class="col-xs-12">
          <h2>If you're me, enter your passphrase here to prove it.</h2>
        </section>
        <section class="col-xs-12 col-sm-10">
          <input type="password"
                 name="passphrase"
                 id="passphrase"
                 class="form-control input-lg"
                 autofocus="autofocus"
                 required="required"
                 placeholder="Hey handsome..."
                 autocomplete="off">
        </section>
        <section class="col-xs-12 col-sm-2">
          <input type="submit" value="Submit" class="form-control input-lg">
        </section>
      </form>
    </div>
  </article>
</apply>
