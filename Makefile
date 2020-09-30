.PHONY: dev yewprint-doc tauri run

# Deploy yewprint-doc to public folder
yewprint-doc:
	cd yewprint && ./build.sh

# Requirements: cargo install simple-http-server
dev:
	cd yewprint && ./dev.sh

run: #yewprint-doc
	scripts/build.sh
