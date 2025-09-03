# tidydirs 0.1
# Install mktdir + tidy-tdirs and a daily cron wrapper

# --- configurable -------------------------------------------------------------
PREFIX      ?= /usr/local
BINDIR      ?= $(PREFIX)/bin
CRONDAILY   ?= /etc/cron.daily
CRONWRAP    ?= $(CRONDAILY)/tidydirs

# If your logger isn't in PATH in cron, set LOGGER here (or leave empty)
LOGGER     ?= logger

# Where root's TDIRS_GLOBAL should default for the cron job
ROOT_HOME  ?= /root

# --- sources -----------------------------------------------------------------
# Expect these scripts to be in the repo root
SCRIPTS := mktdir tidy-tdirs

# --- targets -----------------------------------------------------------------
.PHONY: all install uninstall print-dirs

all:
	@printf "Targets: install | uninstall | print-dirs\n"

print-dirs:
	@echo "BINDIR   = $(BINDIR)"
	@echo "CRONDAILY= $(CRONDAILY)"
	@echo "CRONWRAP = $(CRONWRAP)"

install: $(SCRIPTS)
	@echo ">> Installing scripts to $(BINDIR)"
	install -d -m 0755 "$(BINDIR)"
	install -m 0755 mktdir     "$(BINDIR)/mktdir"
	install -m 0755 tidy-tdirs  "$(BINDIR)/tidy-tdirs"

	@echo ">> Installing daily cron wrapper to $(CRONWRAP)"
	install -d -m 0755 "$(CRONDAILY)"
	# Write wrapper atomically
	{ \
	  echo '#!/bin/sh'; \
	  echo '# tidydirs daily maintenance'; \
	  echo 'set -eu'; \
	  echo 'TDIRS_GLOBAL="$${TDIRS_GLOBAL:-$(ROOT_HOME)/.tdirs_global}"'; \
	  echo 'PATH="$(BINDIR):$$PATH"'; \
	  echo 'if command -v tidy-tdirs >/dev/null 2>&1; then'; \
	  echo '  tidy-tdirs -v | $(LOGGER) -t tidydirs || true'; \
	  echo 'fi'; \
	} > "$(CRONWRAP).new"
	chmod 0755 "$(CRONWRAP).new"
	mv -f "$(CRONWRAP).new" "$(CRONWRAP)"

	@echo ">> Done. Daily cron will call: tidy-tdirs -v"

uninstall:
	@echo ">> Removing scripts from $(BINDIR)"
	rm -f "$(BINDIR)/mktdir" "$(BINDIR)/tidy-tdirs" || true
	@echo ">> Removing cron wrapper $(CRONWRAP)"
	rm -f "$(CRONWRAP)" || true
	@echo ">> Note: ~/.tdirs_global and any .tdirs files are left intact."

