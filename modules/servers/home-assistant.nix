{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "home-assistant";
      packageName = "ha-mcp";
    })
  ];
}
