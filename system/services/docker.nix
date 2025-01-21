{
  virtualisation.docker = {
    enable = true;

    autoPrune = {
      enable = true;
    };
  };

  # Enable CUDA inside containers
  hardware.nvidia-container-toolkit.enable = true;
}
