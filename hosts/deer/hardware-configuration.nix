{
	config,
	lib,
	modulesPath,
	...
}: {
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
	];

	boot.initrd.availableKernelModules = [
		"xhci_pci"
		"ahci"
		"nvme"
		"usb_storage"
		"usbhid"
		"sd_mod"
	];
	boot.initrd.kernelModules = [];
	boot.blacklistedKernelModules = [
		"amdgpu"
		"nouveau"
		"nova"
	];
	boot.kernelModules = ["kvm-amd"];
	boot.kernelParams = [
		"nvidia-drm.modeset=1"
		"modprobe.blacklist=nouveau"
		"modprobe.blacklist=nova"
	];
	boot.extraModulePackages = [];
	nixpkgs.config.allowUnfree = true;

	fileSystems."/" = {
		device = "/dev/disk/by-uuid/4ef1b0c5-c2dd-4c8f-920d-f53f22755af2";
		fsType = "ext4";
	};

	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/C4BC-1414";
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
