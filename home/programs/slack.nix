{ pkgs, ... }:
{
  home.packages = with pkgs; [
    slack
    mattermost
  ];
}
