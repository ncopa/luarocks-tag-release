{self}: final: prev:
with final.pkgs;
with final.lib;
with final.stdenv; let
  luarocks-tag-release-action-wrapped = pkgs.luajitPackages.buildLuaApplication {
    pname = "luarocks-tag-release";
    version = "scm-1";

    src = self;

    propagatedBuildInputs = with pkgs.luajitPackages; [
      dkjson
      luafilesystem
    ];

    meta = {
      description = "Publish Lua packages to LuaRocks";
      homepage = "https://github.com/nvim-neorocks/luarocks-tag-release";
      license = licenses.gpl2Only;
    };
  };

  luarocks-tag-release-action = pkgs.writeShellApplication {
    name = "luarocks-tag-release-action";
    runtimeInputs = with pkgs; [
      curl
      neorocks
      luarocks-tag-release-action-wrapped
      unzip
      zip
    ];

    text = ''
      luarocks-tag-release-action.lua "$@"
    '';

    # The default checkPhase depends on ShellCheck, which depends on GHC
    checkPhase = "";
  };
in {
  inherit
    luarocks-tag-release-action
    ;
}
