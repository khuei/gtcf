#!/usr/bin/env bash

lto() {
	if ! [[ -d ${CARGO_HOME} ]]; then
		local CARGO_HOME="$HOME/.cargo"
		mkdir ${CARGO_HOME}
	fi
	# cargo.eclass uses ${ECARGO_HOME}/config, not config.toml
	cat >> ${CARGO_HOME}/config <<- EOF
	[profile.release]
	lto = "thin"
	EOF
}

bashrcd_phase prepare lto
