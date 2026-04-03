{
	flake,
	inputs,
	lib,
	pkgs,
	config,
	...
}: let
	phinger-cursors-gruvbox-material =
		pkgs.stdenvNoCC.mkDerivation rec {
			pname = "phinger-cursors-gruvbox-material";
			version = "latest";

			src =
				pkgs.fetchurl {
					url = "https://github.com/rehanzo/phinger-cursors-gruvbox-material/releases/download/3328966123/phinger-cursors-variants.tar.bz2";
					sha256 = "sha256-10cc5ygpv3m0ir1gk7dm1f08p777g518d7w1q529idklf1ihc0d8=";
				};

			sourceRoot = ".";

			installPhase = ''
				runHook preInstall

				mkdir -p $out/share/icons
				# Copy all top-level directories (the actual cursor themes)
				cp -r ./* $out/share/icons/ || true

				runHook postInstall
			'';

			meta = with pkgs.lib; {
				description = "Phinger cursor theme recolored to Gruvbox Material";
				homepage = "https://github.com/rehanzo/phinger-cursors-gruvbox-material";
				license = licenses.cc-by-sa-40;
				platforms = platforms.linux;
				maintainers = [];
			};
		};
in
	flake.lib.mkMod {
		inherit lib config;
		name = "pointerCursor";

		home = {
			home.pointerCursor = {
				package = phinger-cursors-gruvbox-material;
				name = "phinger-cursors-gruvbox-material";
				size = 16;
				gtk.enable = true;
				x11.enable = true;
			};

			gtk.cursorTheme = {
				name = "phinger-cursors-gruvbox-material";
				size = 32;
			};
		};
	}
