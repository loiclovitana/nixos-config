{ config, pkgs, ... }:

{
  # Hybrid laptop: AMD Phoenix1 iGPU (PCI c6:00.0) drives the displays and the
  # compositor, the RTX 2000 Ada (PCI 01:00.0) stays powered down until an
  # application is explicitly launched on it. See PRIME offload below.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Steam/Proton and other 32-bit GL clients

    extraPackages = with pkgs; [
      # VA-API on the AMD side (radeonsi). Phoenix's VCN block does the actual
      # decode/encode, so h264/h265/av1 playback never touches the CPU.
      libva-vdpau-driver     # VDPAU-only apps routed onto VA-API
      libvdpau-va-gl         # and the reverse, for the few remaining VDPAU users
      # VA-API on the NVIDIA side. Only picked up when LIBVA_DRIVER_NAME=nvidia
      # is set for a process running under nvidia-offload.
      nvidia-vaapi-driver
    ];
    extraPackages32 = with pkgs; [ libva-vdpau-driver libvdpau-va-gl ];
  };

  # The RADV Vulkan driver ships with mesa and is already in hardware.graphics;
  # the NVIDIA ICD comes from the driver package below. vulkaninfo will list
  # both GPUs.

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Required for Wayland/Hyprland: without KMS the NVIDIA GPU cannot share
    # buffers with the AMD-driven compositor and offloaded windows render black.
    modesetting.enable = true;

    # Ada is fully supported by the open kernel modules, which are the ones
    # NVIDIA actually develops against now.
    open = true;

    nvidiaSettings = true;

    powerManagement = {
      enable = true;       # save/restore VRAM across suspend
      # Turns the card off entirely when no offloaded client is running. This is
      # the whole point of the setup on a laptop -- idle draw goes back to the
      # iGPU-only figure. Requires Turing or newer; Ada qualifies.
      finegrained = true;
    };

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;  # provides the `nvidia-offload` wrapper
      };
      amdgpuBusId = "PCI:198:0:0";  # c6:00.0
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools     # vulkaninfo, vkcube
    libva-utils      # vainfo
    vdpauinfo
    mesa-demos       # glxinfo / eglinfo
    nvtopPackages.full
  ];

  environment.sessionVariables = {
    # Default every process to the iGPU's VA-API driver, since that is what the
    # compositor and every non-offloaded app runs on. To decode on the discrete
    # card instead: `LIBVA_DRIVER_NAME=nvidia nvidia-offload <app>`.
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };
}
