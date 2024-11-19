{
  inputs,
  config,
  ...
}: {
  imports = [
    ./t15g2
  ];

  # perSystem = {system, ...}: {
  #   checks = inputs.deploy-rs.lib.${system}.deployChecks config.deploy;
  # };
}
