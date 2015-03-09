<apply template="base">
  <bind tag="page-title">Secrets In Source Control</bind>
  <article class="container-fluid">
    <h3>Secrets In Source Control</h3>
    <p>This is a talk I gave to the Portland Ansible Meetup on 2015-02-26. I talked about how to use the Vault feature of Ansible to encrypt secrets like SSL keys and store them in source control. If you want to follow along with the slides, <a href="https://docs.google.com/presentation/d/1dBHltWfhDuoQV6tg0DJ5RNiNRzQKx1ZUZ1IWFfLmCE4/edit?usp=sharing">they're shared as a Google Docs presentation</a>.</p>
    <p>You'll want to turn up your speakers, as the audio is fairly quiet.</p>
    <iframe src="//player.vimeo.com/video/121708952"
            width="500"
            height="281"
            allowfullscreen
    ></iframe>
    <p>This talk expands on the ideas I <a href="https://blog.andrewlorente.com/p/using-pgp-to-encrypt-the-ansible-vault">wrote about in a blog post</a> some time earlier. In short, I think layering asymmetric GPG encryption on top of Ansible's symmetcric AES encryption eases some usability problems with the raw Vault.</p>

  </article>
</apply>
