docker_repo:
  pkgrepo.managed:
    - repo: 'deb http://get.docker.io/ubuntu docker main'
    - file: '/etc/apt/sources.list.d/docker.list'
    - key_url: salt://docker/docker.pgp
    - require_in:
      - pkg: lxc-docker

lxc-docker:
  pkg.latest

python-docker:
  pkg.latest

docker:
  service.running
