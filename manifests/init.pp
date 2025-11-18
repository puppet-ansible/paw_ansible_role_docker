# paw_ansible_role_docker
# @summary Manage paw_ansible_role_docker configuration
#
# @param docker_edition Edition can be one of: 'ce' (Community Edition) or 'ee' (Enterprise Edition).
# @param docker_packages
# @param docker_packages_state
# @param docker_obsolete_packages
# @param docker_service_manage Service options.
# @param docker_service_state
# @param docker_service_enabled
# @param docker_service_start_command
# @param docker_restart_handler_state
# @param docker_install_compose_plugin Docker Compose Plugin options.
# @param docker_compose_package
# @param docker_compose_package_state
# @param docker_install_compose Docker Compose options.
# @param docker_compose_version
# @param docker_compose_arch
# @param docker_compose_url
# @param docker_compose_path
# @param docker_add_repo Enable repo setup
# @param docker_repo_url Docker repo URL.
# @param docker_apt_release_channel Used only for Debian/Ubuntu/Pop!_OS/Linux Mint. Switch 'stable' to 'nightly' if needed.
# @param docker_apt_ansible_distribution and is only necessary until Docker officially supports them.
# @param docker_apt_gpg_key
# @param docker_apt_filename
# @param docker_yum_repo_url Used only for RedHat/CentOS/Fedora.
# @param docker_yum_repo_enable_nightly
# @param docker_yum_repo_enable_test
# @param docker_yum_gpg_key
# @param docker_users A list of users who will be added to the docker group.
# @param docker_daemon_options Docker daemon options as a dict
# @param par_tags An array of Ansible tags to execute (optional)
# @param par_skip_tags An array of Ansible tags to skip (optional)
# @param par_start_at_task The name of the task to start execution at (optional)
# @param par_limit Limit playbook execution to specific hosts (optional)
# @param par_verbose Enable verbose output from Ansible (optional)
# @param par_check_mode Run Ansible in check mode (dry-run) (optional)
# @param par_timeout Timeout in seconds for playbook execution (optional)
# @param par_user Remote user to use for Ansible connections (optional)
# @param par_env_vars Additional environment variables for ansible-playbook execution (optional)
# @param par_logoutput Control whether playbook output is displayed in Puppet logs (optional)
# @param par_exclusive Serialize playbook execution using a lock file (optional)
class paw_ansible_role_docker (
  String $docker_edition = 'ce',
  Array $docker_packages = ['docker-{{ docker_edition }}', 'docker-{{ docker_edition }}-cli', 'docker-{{ docker_edition }}-rootless-extras', 'containerd.io', 'docker-buildx-plugin'],
  String $docker_packages_state = 'present',
  Array $docker_obsolete_packages = ['docker', 'docker.io', 'docker-engine', 'docker-doc', 'docker-compose', 'docker-compose-v2', 'podman-docker', 'containerd', 'runc'],
  Boolean $docker_service_manage = true,
  String $docker_service_state = 'started',
  Boolean $docker_service_enabled = true,
  Optional[String] $docker_service_start_command = undef,
  String $docker_restart_handler_state = 'restarted',
  Boolean $docker_install_compose_plugin = true,
  String $docker_compose_package = 'docker-compose-plugin',
  String $docker_compose_package_state = 'present',
  Boolean $docker_install_compose = false,
  String $docker_compose_version = 'v2.32.1',
  String $docker_compose_arch = '{{ ansible_facts.architecture }}',
  String $docker_compose_url = 'https://github.com/docker/compose/releases/download/{{ docker_compose_version }}/docker-compose-linux-{{ docker_compose_arch }}',
  String $docker_compose_path = '/usr/local/bin/docker-compose',
  Boolean $docker_add_repo = true,
  String $docker_repo_url = 'https://download.docker.com/linux',
  String $docker_apt_release_channel = 'stable',
  String $docker_apt_ansible_distribution = '{{ \'ubuntu\' if ansible_facts.distribution in [\'Pop!_OS\', \'Linux Mint\'] else ansible_facts.distribution }}',
  String $docker_apt_gpg_key = '{{ docker_repo_url }}/{{ docker_apt_ansible_distribution | lower }}/gpg',
  String $docker_apt_filename = 'docker',
  String $docker_yum_repo_url = '{{ docker_repo_url }}/{{ \'fedora\' if ansible_facts.distribution == \'Fedora\' else \'rhel\' if ansible_facts.distribution == \'RedHat\' else \'centos\' }}/docker-{{ docker_edition }}.repo',
  String $docker_yum_repo_enable_nightly = '0',
  String $docker_yum_repo_enable_test = '0',
  String $docker_yum_gpg_key = '{{ docker_repo_url }}/{{ \'fedora\' if ansible_facts.distribution == \'Fedora\' else \'rhel\' if ansible_facts.distribution == \'RedHat\' else \'centos\' }}/gpg',
  Array $docker_users = [],
  Hash $docker_daemon_options = {},
  Optional[Array[String]] $par_tags = undef,
  Optional[Array[String]] $par_skip_tags = undef,
  Optional[String] $par_start_at_task = undef,
  Optional[String] $par_limit = undef,
  Optional[Boolean] $par_verbose = undef,
  Optional[Boolean] $par_check_mode = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[String] $par_user = undef,
  Optional[Hash] $par_env_vars = undef,
  Optional[Boolean] $par_logoutput = undef,
  Optional[Boolean] $par_exclusive = undef
) {
# Execute the Ansible role using PAR (Puppet Ansible Runner)
  $vardir = $facts['puppet_vardir'] ? {
    undef   => $settings::vardir ? {
      undef   => '/opt/puppetlabs/puppet/cache',
      default => $settings::vardir,
    },
    default => $facts['puppet_vardir'],
  }
  $playbook_path = "${vardir}/lib/puppet_x/ansible_modules/ansible_role_docker/playbook.yml"

  par { 'paw_ansible_role_docker-main':
    ensure        => present,
    playbook      => $playbook_path,
    playbook_vars => {
      'docker_edition'                  => $docker_edition,
      'docker_packages'                 => $docker_packages,
      'docker_packages_state'           => $docker_packages_state,
      'docker_obsolete_packages'        => $docker_obsolete_packages,
      'docker_service_manage'           => $docker_service_manage,
      'docker_service_state'            => $docker_service_state,
      'docker_service_enabled'          => $docker_service_enabled,
      'docker_service_start_command'    => $docker_service_start_command,
      'docker_restart_handler_state'    => $docker_restart_handler_state,
      'docker_install_compose_plugin'   => $docker_install_compose_plugin,
      'docker_compose_package'          => $docker_compose_package,
      'docker_compose_package_state'    => $docker_compose_package_state,
      'docker_install_compose'          => $docker_install_compose,
      'docker_compose_version'          => $docker_compose_version,
      'docker_compose_arch'             => $docker_compose_arch,
      'docker_compose_url'              => $docker_compose_url,
      'docker_compose_path'             => $docker_compose_path,
      'docker_add_repo'                 => $docker_add_repo,
      'docker_repo_url'                 => $docker_repo_url,
      'docker_apt_release_channel'      => $docker_apt_release_channel,
      'docker_apt_ansible_distribution' => $docker_apt_ansible_distribution,
      'docker_apt_gpg_key'              => $docker_apt_gpg_key,
      'docker_apt_filename'             => $docker_apt_filename,
      'docker_yum_repo_url'             => $docker_yum_repo_url,
      'docker_yum_repo_enable_nightly'  => $docker_yum_repo_enable_nightly,
      'docker_yum_repo_enable_test'     => $docker_yum_repo_enable_test,
      'docker_yum_gpg_key'              => $docker_yum_gpg_key,
      'docker_users'                    => $docker_users,
      'docker_daemon_options'           => $docker_daemon_options,
    },
    tags          => $par_tags,
    skip_tags     => $par_skip_tags,
    start_at_task => $par_start_at_task,
    limit         => $par_limit,
    verbose       => $par_verbose,
    check_mode    => $par_check_mode,
    timeout       => $par_timeout,
    user          => $par_user,
    env_vars      => $par_env_vars,
    logoutput     => $par_logoutput,
    exclusive     => $par_exclusive,
  }
}
