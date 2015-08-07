SHELL := /bin/bash
test: bashate

install: genericinstall

genericinstall:
	 sudo pip install bashate

bashate:
	for f in shutdown/*.sh backup/crowbar-backup; \
	do \
	    echo "checking $$f"; \
	    bash -n $$f || exit 3; \
	    bashate --ignore E010,E011,E020 $$f || exit 4; \
	    ! grep $$'\t' $$f || exit 5; \
	done
