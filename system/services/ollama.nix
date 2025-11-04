{pkgs, ...}: {
  # Local LLM inference engine with NVIDIA GPU acceleration
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
}
