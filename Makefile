PREFIX ?= $(HOME)/.local/share/aws-vpn-cli
SHELL_RC := $(or $(wildcard $(HOME)/.config/zsh/.zshrc),$(wildcard $(HOME)/.zshrc),$(HOME)/.bashrc)

.PHONY: build install uninstall clean

build: saml-server

saml-server: server.go
	go build -o saml-server server.go

install: build
	@if [ ! -d "/Applications/AWS VPN Client" ]; then \
		echo "Error: AWS VPN Client is not installed."; \
		echo "Download it from: https://aws.amazon.com/vpn/client-vpn-download/"; \
		exit 1; \
	fi
	mkdir -p $(PREFIX)
	cp vpn $(PREFIX)/vpn
	cp saml-server $(PREFIX)/saml-server
	cp route-up.sh $(PREFIX)/route-up.sh
	cp dns-down.sh $(PREFIX)/dns-down.sh
	chmod +x $(PREFIX)/vpn $(PREFIX)/route-up.sh $(PREFIX)/dns-down.sh
	@if ! grep -q 'aws-vpn-cli/vpn' "$(SHELL_RC)" 2>/dev/null; then \
		echo '' >> "$(SHELL_RC)"; \
		echo '# AWS VPN CLI' >> "$(SHELL_RC)"; \
		echo 'vpn() { $(PREFIX)/vpn "$$@"; }' >> "$(SHELL_RC)"; \
		echo "Added vpn function to $(SHELL_RC)"; \
	else \
		echo "vpn function already in $(SHELL_RC)"; \
	fi
	@echo ""
	@echo "✓ Installed! Now run:"
	@echo ""
	@echo "    source $(SHELL_RC)"
	@echo "    vpn import"
	@echo "    vpn list"
	@echo ""

uninstall:
	rm -rf $(PREFIX)
	@echo "Removed $(PREFIX)"
	@echo "You may also want to remove the vpn function from $(SHELL_RC)"

clean:
	rm -f saml-server
