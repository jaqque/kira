#!/bin/sh

cd "$HOME" || exit 3

ANSIBLE_VERSION='>=9.1,<9.2' # install latest "reasonable" version
BOOTSTRAP=bootstrap
INVENTORY=inventory.ini
PLAYBOOK=localhost.yml

info() {
  echo 'I:' "$@"
}

error() {
  echo 'E:' "$@"
  exit 1
}

header() {
  echo '==>' "$@"
}

bootstrap() {
  test -d "$BOOTSTRAP" && { info 'Already exists. Skipping.'; return; }
  test -e "$BOOTSTRAP" && error "$BOOTSTRAP exists. Exiting."
  command -v virtualenv > /dev/null \
    || sudo apt-get install --assume-yes virtualenv
  virtualenv --python python3 "$BOOTSTRAP"
}

inventory() {
  test -f "$INVENTORY" && { info 'Already exists. Skipping.'; return; }
  test -e "$INVENTORY" && error "$INVENTORY exists. Exiting."
  info "Creating $INVENTORY"
  echo 'localhost ansible_python_interpreter=/usr/bin/python3 ansible_connection=local' > "$INVENTORY"
}

header 'Creating bootstrap virtualenv'
bootstrap

header 'Activating bootstrap environment'
# shellcheck disable=SC1090,SC1091
. "$BOOTSTRAP/bin/activate"

header 'Installing ansible'
pip install "ansible$ANSIBLE_VERSION"

header 'Creating appropriate inventory file.'
inventory

header 'Setting up localhost'
ansible-playbook --inventory "$INVENTORY" "$PLAYBOOK" "$@"
