{
	flake,
	pkgs,
	inputs,
	lib,
	...
}: {
	imports =
		[
			./hardware-configuration.nix
			inputs.zapret-discord-youtube.nixosModules.default
		]
		++ builtins.attrValues flake.nixosModules;

	config.mods = {
		qtile.enable = true;
		lemurs.enable = true;
		codeTools.enable = true;
		fonts.enable = true;
		pointerCursor.enable = true;
		language.enable = true;
		hardware.enable = true;
		user.enable = true;
		boot = {
			enable = true;
		};
		firefox.enable = true;
		tailscale.enable = true;
		network = {
			enable = true;
			hostName = "spider";
			bypass = true;
		};
		git = {
			enable = true;
			userName = "spider";
			email = "darknekodev@yandex.ru";
		};
		nix = {
			enable = true;
		};
	};

	config = {
		services.flatpak.enable = true;
		xdg.portal.enable = true;
		environment.systemPackages = with pkgs; [
			kitty
			jq
			ipset
			tcpdump
			dig
			wofi
			qutebrowser
			nmap
			wget
			arp-scan
			whois
			setxkbmap
		];

		services.adguardhome = {
			enable = true;
			openFirewall = true;
			settings = {
				dns = {
					bind_hosts = ["0.0.0.0"];
					port = 53;
					upstream_dns = ["127.0.0.1:5353"];
					allowed_clients = ["192.168.0.0/24" "127.0.0.1"];
				};
				filtering = {
					protection_enabled = true;
					filtering_update_interval = 24;
				};
			};
		};

		services.resolved.enable = false;

		services.dnscrypt-proxy = {
			enable = true;
			settings = {
				listen_addresses = ["127.0.0.1:5353"];
				ipv6_servers = false;
				require_dnssec = true;
			};
		};

		networking = {
			firewall = {
				allowedTCPPorts = [67 68 53 3000];
				allowedUDPPorts = [67 68 53];
				extraCommands = ''
					iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
					iptables -A FORWARD -i eno1 -j ACCEPT
						iptables -A FORWARD -o eno1 -j ACCEPT
				'';
			};
			interfaces.eno1.ipv4.addresses = [
				{
					address = "192.168.0.100";
					prefixLength = 24;
				}
			];
			defaultGateway = "192.168.0.1";
			nameservers = ["127.0.0.1" "192.168.0.100"];
		};

		services.zapret-discord-youtube = {
			enable = true;
			configName = "general(ALT3)";
			gameFilter = "all";
			listGeneral = [
				# Telegram
				"t.me"
				"tg.dev"
				"tg.org"
				"tx.me"
				"teleg.xyz"
				"telegram.ai"
				"telegram.asia"
				"telegram.biz"
				"telegram.cloud"
				"telegram.cn"
				"telegram.co"
				"telegram.com"
				"telegram.de"
				"telegram.dev"
				"telegram.dog"
				"telegram.eu"
				"telegram.fr"
				"telegram.host"
				"telegram.in"
				"telegram.info"
				"telegram.io"
				"telegram.jp"
				"telegram.me"
				"telegram.net"
				"telegram.org"
				"telegram.qa"
				"telegram.ru"
				"telegram.services"
				"telegram.solutions"
				"telegram.space"
				"telegram.team"
				"telegram.tech"
				"telegram.uk"
				"telegram.us"
				"telegram.website"
				"telegram.xyz"
				"telegramapp.org"
				"telegra.ph"
				"telesco.pe"
				"nicegram.app"
				"telegramdownload.com"
				"cdn-telegram.org"
				"comments.app"
				"contest.com"
				"fragment.com"
				"graph.org"
				"quiz.directory"
				"tdesktop.com"
				"telega.one"
				"telegram-cdn.org"
				"usercontent.dev"
				"tgram.org"
				"torg.org"

				# Sober infrastructure
				"sober.vinegarhq.org"
				"vinegarhq.org"
				"raw.githubusercontent.com"

				# Roblox core domains
				"roblox.com"
				"www.roblox.com"
				"auth.roblox.com"
				"accountsettings.roblox.com"
				"assetgame.roblox.com"
				"assetdelivery.roblox.com"
				"catalog.roblox.com"
				"avatar.roblox.com"
				"itemconfiguration.roblox.com"
				"economy.roblox.com"
				"apis.roblox.com"
				"clientsettings.api.roblox.com"
				"chat.roblox.com"
				"voice.roblox.com"
				"friends.roblox.com"
				"groups.roblox.com"
				"notifications.roblox.com"
				"presence.roblox.com"
				"realtime.roblox.com"
				"chatmoderation.roblox.com"
				"studio.roblox.com"
				"publish.roblox.com"
				"develop.roblox.com"
				"devforum.roblox.com"
				"setup.rbxcdn.com"
				"rbxcdn.com"
				"versioncompatibility.roblox.com"
				"sitetest.roblox.com"
				"trades.roblox.com"
				"translations.roblox.com"
				"tutorials.roblox.com"
				"ecs.roblox.com"
				"gameanalytics.roblox.com"
				"metrics.roblox.com"
				"telemetry.roblox.com"
				"abtesting.roblox.com"
				"adconfiguration.roblox.com"
				"ads.roblox.com"
				"adserver.roblox.com"
				"adspolicy.roblox.com"
				"api.roblox.com"
				"billing.roblox.com"
				"captcha.roblox.com"
				"cdn.roblox.com"
				"chatrealtime.roblox.com"
				"client-telemetry.roblox.com"
				"clientsettingscdn.roblox.com"
				"clicks.roblox.com"
				"contentstore.roblox.com"
				"ephemeralcounters.api.roblox.com"
				"followings.roblox.com"
				"gamepersistence.roblox.com"
				"games.roblox.com"
				"graphql.roblox.com"
				"groupsmoderation.roblox.com"
				"inventory.roblox.com"
				"locale.roblox.com"
				"localizationtables.roblox.com"
				"matchmaking.roblox.com"
				"pointbalancing.roblox.com"
				"premiumfeatures.roblox.com"
				"privatemessages.roblox.com"
				"ratings.roblox.com"
				"search.roblox.com"
				"thumbnails.roblox.com"
				"tix.roblox.com"
				"translationservice.roblox.com"
				"users.roblox.com"
				"usersmoderation.roblox.com"
				"web.roblox.com"
				"wiki.roblox.com"
				"wire.roblox.com"
				"clientconfig.roblox.co"
				"config.roblox.com"
				"crl.roblox.com"
				"status.roblox.com"
				"setup.roblox.com"
				"update.roblox.com"
				"s3.amazonaws.com"
				"stun.l.google.com"
				"stun1.l.google.com"
				"stun2.l.google.com"
				"stun3.l.google.com"
				"stun4.l.google.com"
				"stun.services.mozilla.com"
				"global.stun.twilio.com"
				"turn.twilio.com"
				"geoip.roblox.com"
				"geoip.services.roblox.com"
				"ocsp.digicert.com"
				"ocsp.verisign.com"
				"crl.verisign.com"
				"setup-cdn.roblox.com"
				"roblox-setup.roblox.com"
				"roblox-update.roblox.com"
				"update-cdn.roblox.com"
				"api.rbxcdn.com"
				"setup.api.rbxcdn.com"
				"setup.cache.rbxcdn.com"
				"cs.rbxcdn.com"
				"roblox-setup.cache.roblox.com"
				"roblox-update.cache.roblox.com"
				"setup.cache.roblox.com"
				"update.cache.roblox.com"
				"chat.roblox.com"
				"gamejoin.roblox.com"
				"client.roblox.com"
				"contentdelivery.roblox.com"
				"economycdn.roblox.com"
				"chatmoderation.roblox.com"
				"matchmaking.api.roblox.com"
				"presence.api.roblox.com"
				"friends.api.roblox.com"
				"groups.api.roblox.com"
				"inventory.api.roblox.com"
				"catalog.api.roblox.com"
				"avatar.api.roblox.com"
				"users.api.roblox.com"
				"develop.api.roblox.com"
				"clientsettingscdn.roblox.com"
				"client-telemetry.roblox.com"
				"telemetry.roblox.com"
				"metrics.roblox.com"
				"gameanalytics.roblox.com"
				"ecs.roblox.com"
				"abtesting.roblox.com"
				"adconfiguration.roblox.com"
				"ads.roblox.com"
				"adserver.roblox.com"
				"adspolicy.roblox.com"
				"billing.roblox.com"
				"captcha.roblox.com"
				"cdn.roblox.com"
				"contentstore.roblox.com"
				"ephemeralcounters.api.roblox.com"
				"followings.roblox.com"
				"games.roblox.com"
				"graphql.roblox.com"
				"groupsmoderation.roblox.com"
				"itemconfiguration.roblox.com"
				"locale.roblox.com"
				"notifications.roblox.com"
				"pointbalancing.roblox.com"
				"premiumfeatures.roblox.com"
				"privatemessages.roblox.com"
				"ratings.roblox.com"
				"realtime.roblox.com"
				"search.roblox.com"
				"tix.roblox.com"
				"trades.roblox.com"
				"tutorials.roblox.com"
				"usersmoderation.roblox.com"
				"wiki.roblox.com"
				"wire.roblox.com"
				"devforum.api.roblox.com"
				"akamaized.net"
				"cloudfront.net"
				"amazonaws.com"
				"rblx.com"
				"robloxapp.com"
				"robloxgames.com"
				"robloxlabs.com"
				"rbx.com"
				"rbxlabs.com"
				"rbxcdn.xyz"
				"rbxcdn.site"
				"rbxcdn.tech"
				"rbxcdn.one"
				"rbxcdn.today"
				"rbxcdn.world"
				"rbxcdn.services"
				"rbxcdn.work"
				"rbxcdn.space"
				"rbxcdn.online"
				"rbxcdn.store"
				"rbxcdn.fun"
				"rbxcdn.biz"
				"rbxcdn.us"
				"rbxcdn.org"
				"rbxcdn.net"
				"rbxcdn.co"
				"rbxcdn.me"
				"rbxcdn.tv"
				"rbxcdn.cc"
				"rbxcdn.gg"
				"rbxcdn.dev"
				"rbxcdn.io"
				"edgecastcdn.net"
				"footprint.net"
				"llnwd.net"
				"hwcdn.net"
				"gcdn.co"
				"g-cdn.net"
				"cdngc.net"
				"cdngs.net"
				"secure.footprint.net"
				"secure.llnwd.net"
				"roblox.qq.com"
				"roblox.cn"

				# Cloudflare
				"cloudflare-dns.com"
			];
			ipsetAll = [
				# Key IP blocks from the Roblox IP list
				"104.18.0.0/16"
				"108.177.0.0/16"
				"128.116.0.0/16"
				"163.181.0.0/16"
				"167.172.0.0/16"
				"172.64.0.0/12"
				"173.194.0.0/16"
				"174.129.0.0/16"
				"18.211.0.0/16"
				"184.51.0.0/16"
				"185.199.0.0/16"
				"2.0.0.0/8"
				"20.201.0.0/16"
				"3.0.0.0/8"
				"35.166.0.0/16"
				"4.209.0.0/16"
				"40.0.0.0/8"
				"52.0.0.0/8"
				"52.38.0.0/16"
				"54.161.0.0/16"
				"57.144.0.0/16"
				"64.233.0.0/16"
				"72.145.0.0/16"
				"74.125.0.0/16"
				"8.6.0.0/16"
				"87.119.0.0/16"
				"95.100.0.0/16"

				# Telegram
				"91.108.4.0/22"
				"91.108.8.0/22"
				"91.108.12.0/22"
				"91.108.16.0/22"
				"91.108.20.0/22"
				"91.108.56.0/22"
				"91.105.192.0/23"
				"95.161.64.0/20"
				"149.154.160.0/20"
				"185.76.151.0/24"
				"5.28.192.0/21"
				"5.28.248.0/21"
				"91.105.192.0/23"
				"91.108.4.0/22"
				"91.108.8.0/20"
				"91.108.36.0/22"
				"91.108.56.0/22"
				"95.161.64.0/19"
				"149.154.160.0/20"
				"185.76.151.0/24"
				"2001:67c:4e8::/48"
				"2001:b28:f23c::/46"
				"2a0a:f280::/29"

				"149.154.167.0/22"
				"149.154.175.0/22"
				"149.154.250.0/22"
				"149.154.164.0/22"
				"194.221.250.0/24"
			];

			listExclude = [
				"duckduckgo.com"
			];
			ipsetExclude = ["192.168.0.0/24"];
		};

		boot.kernel.sysctl = {
			"net.ipv4.ip_forward" = 1;
			"net.ipv6.conf.all.forwarding" = 1;
		};

		home-manager = {
			backupFileExtension = "backup";
			overwriteBackup = true;
		};

		nixpkgs.hostPlatform = "x86_64-linux";
		system.stateVersion = "25.05";
	};
}
