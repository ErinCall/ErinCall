from fabric.api import cd, run, sudo, env, execute, task, local
from datetime import datetime

env.hosts = ['andrewlorente.com']

@task
def deploy(app):
    if app not in apps.keys():
        raise Exception("Unknown deploy target '{0}'".format(app))

    release_id = datetime.now().strftime("%Y%m%d%H%M%S")
    release_dir = "/u/apps/{0}/releases/{1}".format(app, release_id)
    repo = apps[app].get('repo', app)

    execute(checkout, repo, release_dir, hosts=apps[app]['hosts'])
    execute(apps[app]['build'], app, release_dir, hosts=apps[app]['hosts'])
    if 'extra' in apps[app]:
        extra = apps[app]['extra']
        if hasattr(extra, '__iter__'):
            for action in extra:
                execute(action, app, release_dir, hosts=apps[app]['hosts'])
        else:
            execute(extra, app, release_dir, hosts=apps[app]['hosts'])

    execute(update_symlink, app, release_dir, hosts=apps[app]['hosts'])
    if 'restart' in apps[app]:
        for service in apps[app]['restart']:
            execute(restart, service, hosts=['alorente@andrewlorente.com'])
    else:
        execute(restart, app, hosts=['alorente@andrewlorente.com'])

def checkout(repo, release_dir):
    repo = "https://git.andrewlorente.com/AndrewLorente/{0}.git".format(repo)
    run("git clone -q {0} {1}".format(repo, release_dir))

def build_haskell(app, release_dir):
    with cd(release_dir):
        run("cabal update")
        run("cabal install --constraint 'template-haskell installed' "
            "--dependencies-only --force-reinstall")
        run("cabal configure")
        run("cabal build")

def build_js(app, release_dir):
    with cd(release_dir):
        run("npm install")

def build_python_with_setup(app, release_dir):
    return build_python(app, release_dir, 'Env/bin/python setup.py develop')

def build_python_with_requirements(app, release_dir):
    return build_python(app, release_dir, 'Env/bin/pip install -r requirements.txt')

def build_python(app, release_dir, requirements_command):
    with cd(release_dir):
        run("virtualenv Env")
        run("source Env/bin/activate")
        run(requirements_command)

def link_session_key(app, release_dir):
    run("ln -nfs /u/apps/{0}/shared/session_key.txt "
        "{1}/session_key.txt".format(app, release_dir))

def dotenv(app, release_dir):
    run("ln -nfs /u/apps/{0}/shared/.env {1}/.env".format(app, release_dir))

def yoyo_migrate(app, release_dir):
    run("DATABASE_URL=$(grep DATABASE_URL {0}/.env | sed s/DATABASE_URL=//); "
        "{0}/Env/bin/yoyo-migrate -b apply {0}/migrations $DATABASE_URL".
        format(release_dir))

def update_symlink(app, release_dir):
    run("ln -nfs {0} /u/apps/{1}/current".format(release_dir, app))

def restart(app):
    sudo("initctl restart " + app)

@task
def puppet():
    local('bundle exec cap production puppet:apply')

apps = {
    'bloge': {
        'build': build_haskell,
        'hosts': ['bloge@andrewlorente.com'],
    },
    'andrewlorente': {
        'build': build_haskell,
        'hosts': ['andrewlorente@andrewlorente.com'],
        'extra': link_session_key,
    },
    'catsnap': {
        'build': build_python_with_setup,
        'hosts': ['catsnap@andrewlorente.com'],
        'extra': [dotenv, yoyo_migrate],
        'restart': ['catsnap', 'catsnap-worker']
    },
    'identity': {
        'build': build_python_with_requirements,
        'hosts': ['identity@andrewlorente.com'],
        'extra': dotenv,
    },
    'paste': {
        'build': build_js,
        'hosts': ['paste@andrewlorente.com'],
        'repo': 'haste-server',
    },
}

