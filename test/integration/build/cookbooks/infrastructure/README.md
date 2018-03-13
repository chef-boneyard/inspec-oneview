# infrastructure

The infrastructure cookbook will create the environment in HPE OneView so that the integration tests can be executed.

Only the following OneView resources are currently enabled:

- OneView Ethernet Network
- OneView FC Network
- OneView Logical Interconnect Group (for ethernet)

To build the environment an attributes file needs to be created that contains connection informantion to the OneView platform.

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

Once this is in place and saved to a known location then `chef-client` can be used in local mode to build the environment.

```
chef-client -z -j attributes.json
```

NOTE: More OneView resources are configured in the cookbook, however they have been disabled in the attributes. This is because they are do not work correctly and cause the environment creation to fail.