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
		"ahci"
		"xhci_pci"
		"usb_storage"
		"sd_mod"
		"rtsx_usb_sdmmc"
	];
	boot.initrd.kernelModules = [];
	boot.kernelModules = ["kvm-intel"];
	boot.extraModulePackages = [];

	fileSystems."/" = {
		device = "/dev/disk/by-uuid/bda67f93-75a7-4dc6-a95f-2713e887f960";
		fsType = "ext4";
	};

	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/5A0A-0D43";
		fsType = "vfat";
		options = [
			"fmask=0077"
			"dmask=0077"
		];
	};

	swapDevices = [];

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
