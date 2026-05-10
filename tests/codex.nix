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
in
{
  test-codex =
    pkgs.runCommand "test-codex"
      {
        nativeBuildInputs = with pkgs; [ ];
      }
      ''
        export CODEX_HOME=$(mktemp -d)
        codex -c "$(cat ${testConfig})" mcp list | grep -e filesystem > $out
      '';
}
