PREFIX ?= $(HOME)/.local/share/aws-vpn-cli
BIN_DIR ?= /usr/local/bin
ZSH_COMPLETIONS ?= /usr/local/share/zsh/site-functions

.PHONY: build install uninstall clean

build: saml-server

saml-server: server.go
	go build -o saml-server server.go

install: build
	@if [ ! -d "/Applications/AWS VPN Client" ]; then \
		echo "✗ AWS VPN Client is not installed."; \
		echo "  Download it from: https://aws.amazon.com/vpn/client-vpn-download/"; \
		exit 1; \
	fi
	mkdir -p $(PREFIX)
	cp vpn $(PREFIX)/vpn
	cp saml-server $(PREFIX)/saml-server
	cp route-up.sh $(PREFIX)/route-up.sh
	cp dns-down.sh $(PREFIX)/dns-down.sh
	chmod +x $(PREFIX)/vpn $(PREFIX)/route-up.sh $(PREFIX)/dns-down.sh
	sudo mkdir -p $(ZSH_COMPLETIONS)
	sudo ln -sf $(PREFIX)/vpn $(BIN_DIR)/vpn
	sudo cp _vpn $(ZSH_COMPLETIONS)/_vpn
	@echo ""
	@echo "✓ Installed! Run: vpn import"
	@echo ""

uninstall:
	@$(BIN_DIR)/vpn disconnect 2>/dev/null || true
	rm -rf $(PREFIX)
	sudo rm -f $(BIN_DIR)/vpn
	sudo rm -f $(ZSH_COMPLETIONS)/_vpn
	@echo "✓ Uninstalled (profiles kept in ~/.config/aws-vpn-cli/)"

purge: uninstall
	rm -rf $(HOME)/.config/aws-vpn-cli
	@echo "✓ Profiles removed"

clean:
	rm -f saml-server
