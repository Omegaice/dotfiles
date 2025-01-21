{
  self,
  inputs,
  ...
}: {
  deploy.nodes.t15g2 = {
    hostname = "10.42.1.224";
    fastConnection = true;
    interactiveSudo = true;
    profiles = {
      system = {
        sshUser = "root";
        path =
          inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.t15g2;
        user = "root";
      };
    };
  };
}