{
  config,
  pkgs,
  dotfiles,
  ...
}:

{

  home = {
    packages = with pkgs; [
      docker-compose-language-service
      dockerfile-language-server
      hadolint
      intelephense
      lua-language-server
      markdown-toc
      markdownlint-cli2
      prettier
      shfmt
      stylua
      tailwindcss-language-server
      tree-sitter
      vscode-langservers-extracted
      vtsls
      yaml-language-server
    ];
    file = {
      "intelephense" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/secrets/intelephense";
      };
    };
  };

  xdg = {
    configFile = {
      "nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
      };
    };
  };

}
