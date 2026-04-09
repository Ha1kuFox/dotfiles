{
	config,
	lib,
	modulesPath,
	...
}: {
	imports = [(modulesPath + "/installer/scan/not-detected.nix")];

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};

	boot.initrd.availableKernelModules = [
		"xhci_pci"
		"ahci"
		"nvme"
		"usbhid"
		"sd_mod"
	];
	boot.initrd.kernelModules = ["amdgpu"];
	boot.kernelModules = ["kvm-amd"];
	boot.extraModulePackages = [];

	fileSystems."/" = {
		device = "/dev/disk/by-uuid/fc16b479-f19f-4cf7-b5db-0ca76a83aaf1";
		fsType = "ext4";
	};

	fileSystems."/mnt/games" = {
		device = "/dev/disk/by-uuid/f7ec0ea0-ee9e-4e98-972f-dfc1d700de2d";
		fsType = "ext4";
		options = [
			"defaults"
			"nofail"
			"x-systemd.automount"
			"x-gvfs-show"
		];
	};

	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/2B2E-07C9";
		fsType = "vfat";
		options = [
			"fmask=0077"
			"dmask=0077"
		];
	};

	swapDevices = [];

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
