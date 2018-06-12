# InSpec for Oneview

# Getting Started

This profile requires the InSpec [HPE Oneview plugin](https://github.com/inspec/inspec-hpe-oneview) to be installed and configured. Test this is working via:
```
inspec-hpe-oneview spaterson$ bundle exec inspec detect -t oneview://

== Platform Details

Name:      oneview
Families:  iaas, api
Release:   oneview-v5.5.0
```

Configuration information is specified in a default file `~/.oneview/inspec` or it can be overridden using the environment variable `INSPEC_ONEVIEW_SETTINGS`.

To to run the profile now it is as simple as running:

```bash
inspec exec inspec-oneview -t oneview://
```

Alternatively, using the environment variable `INSPEC_ONEVIEW_SETTINGS`:

```bash
INSPEC_ONEVIEW_SETTING"/path/to/another/file" inspec exec inspec-oneview
```

## Use the resources

Since this is an InSpec resource pack, it only defines InSpec resources. It includes example tests only. To easily use the Oneview resources in your tests do the following:

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
 - [Oneview FC Network](docs/resources/oneview_fc_network.md)
 - [Oneview Enclosure Group](docs/resources/oneview_enclosure_group.md)

The below resources are available pending resolution of some issues, [see notes here](#important-integration-test-setup-limitation):

 - [Oneview Enclosure Group Bay Mappings](docs/resources/oneview_enclosure_group_interconnect_bay_mappings.md)
 - [Oneview Enclosure Group Port Mappings](docs/resources/oneview_enclosure_group_port_mappings.md)
 - [Oneview FC Network](docs/resources/oneview_fc_network.md)
 - [Oneview Generic Resource](docs/resources/oneview_generic_resource.md) 
 - [Oneview Servers](docs/resources/oneview_servers.md)
 - [Oneview Server Profiles](docs/resources/oneview_server_profile.md)
 - [Oneview Server Profile Connections](docs/resources/oneview_server_profile_connections.md)

 All of the documention is based on version `300` of the OneView API.

# Integration Testing

Our integration tests spin up resources in Oneview using a cookbook in local mode and the results are verified by InSpec. The `test/integration/verify/controls` directory contains all of the tests that are run during the integration tests. These can be used as examples of how to use this resource pack.

In oder to run the integration tests both Berkshelf and chef-client are required. These will both be installed if you have ChefDK installed. 

The cookbooks runs locally on your machine and remotes into the specified OneView environment using connection settings that are passed in as attributes.

As a minimum the attributes file that is passed to the test must have the following

```json
{
  "infrastructure": {
    "connection": {
      "url": "https://192.168.1.1",
      "username": "my_user",
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

When Berkshelf is used to vendor the cookbooks they are placed into the `test/integration/build/vendor/cookbooks` directory.

NOTE: `chef-client` expects to be run with admin privileges. So if running on MacOS or Linux please use `sudo` or if on Windows ensure the process is being run in an elevated PowerShell or Command Prompt. No changes will be made to your local system.

## Chef DK Version

This resource pack has been tested against ChefDK version 2.5.3.  This version is recommended for now to avoid dependency conflicts.  

## IMPORTANT Integration Test Setup Limitation

After live testing the following issues were discovered: 
- [https://github.com/chef/inspec-oneview/issues/4](https://github.com/chef/inspec-oneview/issues/4)
- [https://github.com/chef/inspec-oneview/issues/5](https://github.com/chef/inspec-oneview/issues/5)
- [https://github.com/chef/inspec-oneview/issues/6](https://github.com/chef/inspec-oneview/issues/6)
- [https://github.com/chef/inspec-oneview/issues/7](https://github.com/chef/inspec-oneview/issues/7)

These issues make it impossible to automatically create the infrastructure required for all the controls.  As such the affected tests have been disabled pending the resolution of these issues.

In the meantime, the following sample JSON is currently recommended to run the integration tests:
```json
{
  "infrastructure": {
    "connection": {
      "url": "https://192.168.1.1",
      "username": "my_user",
      "password": "my_password",
      "api_version": 300,
      "ssl_enabled": false
    },
    "network" : {
      "fc": {
        "associated_san":""
      }
    },
   "server_profile_template": {
     "server_hardware_type":"SY 480 Gen10 1"
   }    
  }
}
```

Please update the *server_hardware_type* field corresponding to your setup.  A test flag *inspec_oneview_disable_affected_tests* has been added such that InSpec will skip the tests known to fail due to the above.  This flag is disabled by default.


# Example screen cast

The following screen cast shows some of the integration tests being run against the HPE OneView Simulator.
NOTE Some of the OneView resources have been modified using the WebUI so that enhanced testing of them can be performed. It is likely that this will display different output to what you would see if you run these tests now.

[![asciicast](https://asciinema.org/a/170213.png)](https://asciinema.org/a/170213)

# Profile Class Documentation

Documentation can be generated for the profile using `yardoc`. A Thor task has been created which will run the Yard generator and create the documentation in `docs/profile`.

```bash
thor docs:create
```

Once the documentation has been generated view it by going to [file://docs/profile/index.html](file://docs/profile/index.html).

# FAQ

## Error calling OneView API `ERROR -- : SSL verification failed for request`

As suggested by the resulting output, run the following to import the certificates locally:
```
$ bundle exec oneview-sdk-ruby cert import https://192.168.1.1
Importing certificate for 'https://10.0.0.123' into '/Users/spaterson/.oneview-sdk-ruby/trusted_certs.cer'...
Cert added to '/Users/spaterson/.oneview-sdk-ruby/trusted_certs.cer'. Cert Info:
OneView at https://192.168.1.1
=============================
-----BEGIN CERTIFICATE-----
MIIEDjCCSDKLJSDafgICJiowDQYJKoZIhvcNAQELBQAwdzELMAkGA1UEBhMCVVMx
EzARBgNVBAgMCkNhbGlmb3JuaWExEjasdfasdfafdVBhbG8gQWx0bzEjMCEGA1UE
...
-----END CERTIFICATE-----
```


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
