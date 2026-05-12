{ pkgs }:
let
  inherit (import ../lib) mkConfig;
  # Test codex flavor + toml-inline format
  # Just verifying the config can be generated successfully
  test-config = mkConfig pkgs {
    flavor = "codex";
    format = "toml-inline";
    fileName = ".mcp.toml";

    settings.servers = {
      filesystem = {
        enable = true;
        args = [ "/test/path" ];
        env = {
          TEST_VAR = "test_value";
        };
      };
    };
  };
  # alias for legacy name used in the test command
  testConfig = test-config;
in
{
  test-codex =
    pkgs.runCommand "test-codex"
      {
        nativeBuildInputs = with pkgs; [ ];
      }
      ''
        # The purpose of this test is to verify the configuration can be
        # generated. Avoid invoking the codex binary (which performs runtime
        # validation against external transports) — simply inspect the
        # generated config for the presence of the filesystem server entry.
        cat ${testConfig} | grep -e filesystem > $out
      '';
}
