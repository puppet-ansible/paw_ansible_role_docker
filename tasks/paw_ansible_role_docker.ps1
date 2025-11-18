# Puppet task for executing Ansible role: ansible_role_docker
# This script runs the entire role via ansible-playbook

$ErrorActionPreference = 'Stop'

# Determine the ansible modules directory
if ($env:PT__installdir) {
  $AnsibleDir = Join-Path $env:PT__installdir "lib\puppet_x\ansible_modules\ansible_role_docker"
} else {
  # Fallback to Puppet cache directory
  $AnsibleDir = "C:\ProgramData\PuppetLabs\puppet\cache\lib\puppet_x\ansible_modules\ansible_role_docker"
}

# Check if ansible-playbook is available
$AnsiblePlaybook = Get-Command ansible-playbook -ErrorAction SilentlyContinue
if (-not $AnsiblePlaybook) {
  $result = @{
    _error = @{
      msg = "ansible-playbook command not found. Please install Ansible."
      kind = "puppet-ansible-converter/ansible-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Check if the role directory exists
if (-not (Test-Path $AnsibleDir)) {
  $result = @{
    _error = @{
      msg = "Ansible role directory not found: $AnsibleDir"
      kind = "puppet-ansible-converter/role-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
$CollectionPlaybook = Join-Path $AnsibleDir "roles\paw_ansible_role_docker\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\paw_ansible_role_docker"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\paw_ansible_role_docker"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_docker_edition) {
  $ExtraVars['docker_edition'] = $env:PT_docker_edition
}
if ($env:PT_docker_packages) {
  $ExtraVars['docker_packages'] = $env:PT_docker_packages
}
if ($env:PT_docker_packages_state) {
  $ExtraVars['docker_packages_state'] = $env:PT_docker_packages_state
}
if ($env:PT_docker_obsolete_packages) {
  $ExtraVars['docker_obsolete_packages'] = $env:PT_docker_obsolete_packages
}
if ($env:PT_docker_service_manage) {
  $ExtraVars['docker_service_manage'] = $env:PT_docker_service_manage
}
if ($env:PT_docker_service_state) {
  $ExtraVars['docker_service_state'] = $env:PT_docker_service_state
}
if ($env:PT_docker_service_enabled) {
  $ExtraVars['docker_service_enabled'] = $env:PT_docker_service_enabled
}
if ($env:PT_docker_service_start_command) {
  $ExtraVars['docker_service_start_command'] = $env:PT_docker_service_start_command
}
if ($env:PT_docker_restart_handler_state) {
  $ExtraVars['docker_restart_handler_state'] = $env:PT_docker_restart_handler_state
}
if ($env:PT_docker_install_compose_plugin) {
  $ExtraVars['docker_install_compose_plugin'] = $env:PT_docker_install_compose_plugin
}
if ($env:PT_docker_compose_package) {
  $ExtraVars['docker_compose_package'] = $env:PT_docker_compose_package
}
if ($env:PT_docker_compose_package_state) {
  $ExtraVars['docker_compose_package_state'] = $env:PT_docker_compose_package_state
}
if ($env:PT_docker_install_compose) {
  $ExtraVars['docker_install_compose'] = $env:PT_docker_install_compose
}
if ($env:PT_docker_compose_version) {
  $ExtraVars['docker_compose_version'] = $env:PT_docker_compose_version
}
if ($env:PT_docker_compose_arch) {
  $ExtraVars['docker_compose_arch'] = $env:PT_docker_compose_arch
}
if ($env:PT_docker_compose_url) {
  $ExtraVars['docker_compose_url'] = $env:PT_docker_compose_url
}
if ($env:PT_docker_compose_path) {
  $ExtraVars['docker_compose_path'] = $env:PT_docker_compose_path
}
if ($env:PT_docker_add_repo) {
  $ExtraVars['docker_add_repo'] = $env:PT_docker_add_repo
}
if ($env:PT_docker_repo_url) {
  $ExtraVars['docker_repo_url'] = $env:PT_docker_repo_url
}
if ($env:PT_docker_apt_release_channel) {
  $ExtraVars['docker_apt_release_channel'] = $env:PT_docker_apt_release_channel
}
if ($env:PT_docker_apt_ansible_distribution) {
  $ExtraVars['docker_apt_ansible_distribution'] = $env:PT_docker_apt_ansible_distribution
}
if ($env:PT_docker_apt_gpg_key) {
  $ExtraVars['docker_apt_gpg_key'] = $env:PT_docker_apt_gpg_key
}
if ($env:PT_docker_apt_filename) {
  $ExtraVars['docker_apt_filename'] = $env:PT_docker_apt_filename
}
if ($env:PT_docker_yum_repo_url) {
  $ExtraVars['docker_yum_repo_url'] = $env:PT_docker_yum_repo_url
}
if ($env:PT_docker_yum_repo_enable_nightly) {
  $ExtraVars['docker_yum_repo_enable_nightly'] = $env:PT_docker_yum_repo_enable_nightly
}
if ($env:PT_docker_yum_repo_enable_test) {
  $ExtraVars['docker_yum_repo_enable_test'] = $env:PT_docker_yum_repo_enable_test
}
if ($env:PT_docker_yum_gpg_key) {
  $ExtraVars['docker_yum_gpg_key'] = $env:PT_docker_yum_gpg_key
}
if ($env:PT_docker_users) {
  $ExtraVars['docker_users'] = $env:PT_docker_users
}
if ($env:PT_docker_daemon_options) {
  $ExtraVars['docker_daemon_options'] = $env:PT_docker_daemon_options
}

$ExtraVarsJson = $ExtraVars | ConvertTo-Json -Compress

# Execute ansible-playbook with the role
Push-Location $PlaybookDir
try {
  ansible-playbook playbook.yml `
    --extra-vars $ExtraVarsJson `
    --connection=local `
    --inventory=localhost, `
    2>&1 | Write-Output
  
  $ExitCode = $LASTEXITCODE
  
  if ($ExitCode -eq 0) {
    $result = @{
      status = "success"
      role = "ansible_role_docker"
    }
  } else {
    $result = @{
      status = "failed"
      role = "ansible_role_docker"
      exit_code = $ExitCode
    }
  }
  
  Write-Output ($result | ConvertTo-Json)
  exit $ExitCode
}
finally {
  Pop-Location
}
