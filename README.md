# InSpec for Oneview

# Getting Started

This profile uses the Oneview SDK from HP to communicate with Oneview. As such itrequires configuration information, this is specified in a default file `~/.oneview/inspec` or it can be overridden using the environment variable `INSPEC_ONEVIEW_SETTINGS`.

## Settings File

This file requires the following information:

| Parameter | Description | Example Value |
|---|---|---|
| url | URL to the Oneview server | https://192.168.1.93 |
| user | Username to connect to Onwview with | myuser |
| password | Password associated with the specified user |
| api_version | The API version to use. The default value is 200 | 300 |

This file can be written out in JSON or YAML.

```json
{
    "url": "https://192.168.1.93",
    "user": "myuser",
    "password": "12345",
    "api_version": 300
}
```

```yaml
url: https://192.168.1.93
user: myuser
password: 12345
api_version: 300
```

So to run the profile now it is as simple as running:

```bash
inspec exec inspec-oneview
```

A different settings file, with the same format, can be specified as an environment variable `INSPEC_ONEVIEW_SETTINGS`:

```bash
INSPEC_ONEVIEW_SETTING"/path/to/another/file" inspec exec inspec-oneview
```

## Use the resources

Since this is an InSpec resource pack, it only defines InSpec resources. It includes example tests only. To easily use the Oneview resources in your testsdo the following:

### Create a new profile

```bash
inspec init profile my-profile
```

```yaml
name: my-profile
title: My own Oneview profile
version: 0.1.0
depends:
  - name: oneview
    url: https://github.com/chef-partners/inspec-oneview/archive/master.tar.gz
```

### Add Controls

Sine your profile depends on the InSpec resource pack, you can use the resources here in your own profile. In this example an ethernet network from Oneview is being tested.

```ruby
control 'oneview-1' do
  impact 1.0
  title 'Checks that a specific network has been configured correctly'

  describe oneview_ethernet_network(name: 'InSpec-Ethernet-Network') do
    its('type') { should cmp 'ethernet-networkV300' }
    its('ethernet_network_type') { should cmp 'Tagged' }
    its('vlan_id') { should eq 1 }  end
end
```

There are a few different ways in which tests can be written, which mean that arrays can be tested. A lot of the different ways and techniques are shown and documented in the integrations tests which are highly recommended reading.

### Available Resources

The following resources are available in the InSpec Oneview Profile

 - [Oneview Generic Resource](docs/resources/oneview_generic_resource.md)
 - [Oneview Ethernet Network](docs/resources/oneview_ethernet_network.md)

# Integration Testing

Our intergration tests spin up resources in Oneview using Terraform and the results are verified by InSpec. The `test/integration/verify/controls` directory contains all of the tests that are run during the integration tests. These can be used as examples of how to use this resource pack.

Rake tasks have been configured to allow the easy execution of the integration tests:

```bash
rake lint               # Run the robocop linter
rake rubocop            # Run Rubocop lint checks
rake test:integration   # Perform Integration tests
```

# Profile Class Documentation

Documentation can be generated for the profile using `yardoc`. A rake task has been 