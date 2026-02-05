# paw_ansible_role_docker

## Description

This Puppet module was Converted from Ansible role: **ansible_role_docker**

Docker for Linux.

## Conversion Details

- **Converted on**: 2026-02-05
- **Original Author**: geerlingguy
- **License**: license (BSD, MIT)

## Usage

Include the module in your Puppet manifest:

```puppet
include paw_ansible_role_docker
```

Or with custom parameters:

```puppet
class { 'paw_ansible_role_docker':
  # Add your parameters here
}
```

## Parameters

See `manifests/init.pp` for the full list of available parameters.

## Requirements

- Puppet 6.0 or higher
- puppet_agent_runonce module for task execution
- Ansible installed on target nodes for task execution

## License

license (BSD, MIT)
