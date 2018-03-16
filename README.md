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

 - [Oneview Ethernet Network](docs/resources/oneview_ethernet_network.md)
 - [Oneview Enclosure Group](docs/resources/oneview_enclosure_group.md)
 - [Oneview Enclosure Group Bay Mappings](docs/resources/oneview_enclosure_group_bay_mappings.md)
 - [Oneview Enclosure Group Port Mappings](docs/resources/oneview_enclosure_group_port_mappings.md)
 - [Oneview FC Network](docs/resources/ineview_fc_network.md)
 - [Oneview Generic Resource](docs/resources/oneview_generic_resource.md) 
 - [Oneview Servers](docs/resources/oneview_servers.md)
 - [Oneview Server Profiles](docs/resources/oneview_server_profiles.md)
 - [Oneview Server Profile Connections](docs/resources/oneview_server_profile_connections.md)

 All of the documention is based on version `300` of the OneView API.

# Integration Testing

Our integration tests spin up resources in Oneview using a cookbook in local mode and the results are verified by InSpec. The `test/integration/verify/controls` directory contains all of the tests that are run during the integration tests. These can be used as examples of how to use this resource pack.

In oder to run the inetgration tests both Berkshelf and chef-client are required. These will both be installed if you have ChefDK installed.
The cookbooks runs locally on your machine and remotes into the specified OneView environment using connection settings that are passed in as attributes.

As a minimum the attributes file that is passed to the test must have the following

```json
{
  "infrastructure": {
    "connection": {
      "url": "https://192.168.1.1",
      "user": "my_user",
      "password": "my_password",
      "api_version": 300,
      "ssl_enabled": false
    }
  }
}
```

Thor tasks have been configured to allow the easy execution of the integration tests:

```bash
thor lint:rubocop                                                     # Run the robocop linter
thor test:integration --attributes local\infrastructure.json          # Run Rubocop lint checks
```

The `test:integration` task will run all of the following in order, however these can be called manually in order if required.

```bash
thor test:vendor_cookbooks
thor test:cleanup
thor test:setup_integration --attributes local\infrastructure.json
thor test:execute
thor test:cleanup --attributes local\infrastructure.json
```

When Berkshelf is used ot vendor the cookbooks they are placed into the `test/integration/build/vendor/cookbooks` directory.

NOTE: `chef-client` expects to be run with admin privileges. So if running on MacOS or Linux please use `sudo` or if on Windows ensure the process is being run in an elevated PowerShell or Command Prompt. No changes will be made to your local system.

The following screen cast shows some of the integration tests being run against the HPE OneView Simulator.
NOTE Some of the OneView resources have been modified using the WebUI so that enhanced testing of them can be performed. It is likely that this will display different output to what you would see if you run these tests now.

[![asciicast](https://asciinema.org/a/170213.png)](https://asciinema.org/a/170213)

# Profile Class Documentation

Documentation can be generated for the profile using `yardoc`. A Thor task has been created which will run the Yard generator and create the documentation in `docs/profile`.

```bash
thor docs:create
```

Once the documentation has been generated view it by going to [file://docs/profile/index.html](file://docs/profile/index.html).

# Contributing

To contribute to the resource, please clone the repo make your changes and create a PR.

To aid in creating new resources, a Thor task has been created. The syntax of this command is:

```
thor generate:resource NAME DESCRIPTION TYPE [--multiple]
```

| Name | Description | Required? | Default Value | Example |
|---|---|---|---|---|
| NAME | Name of the resource | Y | | `oneview_server_profile` |
| DESCRIPTION | A descriptionof the resource that will be displayed in InSpec output | Y | | | 
| TYPE | The type of resource in the OneView API | Y | | `server-profiles` |
| multiple | State if multiple objects are to be returned and a FilterTable should be created | N | false | |

This will create a new resource with the specified name in `/libraries`.

## License

|  |  |
| ------ | --- |
| **Author:** | Russell Seymour (<russell@chef.io>) |
| **Copyright:** | Copyright (c) 2018 Chef Software Inc. |
| **License:** | Apache License, Version 2.0 |

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.