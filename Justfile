dev:
	npm run dev

# Build the static site into dist/. Caddy serves this at https://cv.dev
# (see the jobz repo's private-notes/daemon for the machine-wide proxy setup).
build:
	npm run build

publish:
	@npm run build
	@npm run generate-pdf
	@echo "----> Publishing to netlify"
	@netlify deploy --prod -d dist

gen-pdf:
	npm run build
	npm run generate-pdf

# --- watch-pdf daemon -------------------------------------------------------
# On any src/**/*.elm change, rebuild dist/ and regenerate only the affected
# variant PDFs (see scripts/watch-pdf.js). Runs under launchd: starts at login,
# restarts on crash. Don't also run `just watch-pdf-fg` alongside it, or every
# change builds twice.

plist := "co.opsb.cv-elm"
plist_src := "private-notes/daemon/co.opsb.cv-elm.plist"
plist_dst := "/Users/opsb/Library/LaunchAgents/co.opsb.cv-elm.plist"

# Install + start the launchd daemon (copies the plist and bootstraps it).
daemon-install:
	cp {{plist_src}} {{plist_dst}}
	launchctl bootout gui/$(id -u)/{{plist}} 2>/dev/null || true
	launchctl bootstrap gui/$(id -u) {{plist_dst}}
	launchctl enable gui/$(id -u)/{{plist}}
	@echo "daemon installed and running -> private-notes/daemon/logs/"

# Stop + remove the launchd daemon.
daemon-uninstall:
	launchctl bootout gui/$(id -u)/{{plist}} 2>/dev/null || true
	rm -f {{plist_dst}}
	@echo "daemon uninstalled"

# Apply edits to the plist or script: reload from the source plist.
daemon-restart: daemon-install

daemon-status:
	@launchctl print gui/$(id -u)/{{plist}} 2>/dev/null | grep -E "state =|pid =" || echo "daemon not loaded"

daemon-logs:
	@tail -f private-notes/daemon/logs/watch-pdf.out.log private-notes/daemon/logs/watch-pdf.err.log

# Run the watcher in the foreground (manual alternative to the daemon; Ctrl-C
# to stop). Does the one-off full regen first unless WATCH_SKIP_INITIAL=1.
watch-pdf-fg:
	node scripts/watch-pdf.js
