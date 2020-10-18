#!/usr/bin/env bash
# (C) Martin V\"ath <martin at mvath.de>
# SPDX-License-Identifier: GPL-2.0-only

FLAG_FILTER_C_CXX=(
	'-fall-intrinsics'
	'-fbackslash'
	'-fcray-pointer'
	'-fd-lines-as-*'
	'-fdec*'
	'-fdefault-*'
	'-fdollar-ok'
	'-ffixed-*'
	'-ffree-*'
	'-fimplicit-none'
	'-finteger-4-integer-8'
	'-fmax-identifier-length*'
	'-fmodule-private'
	'-fno-range-check'
	'-freal-*'
	'-ftest-forall-temp'
	'-std=f*'
	'-std=gnu'
	'-std=legacy'
)

FLAG_FILTER_CXX_FORTRAN=(
	'-std=c1*'
	'-std=c8*'
	'-std=c9*'
	'-std=gnu1*'
	'-std=gnu8*'
	'-std=gnu9*'
	'-std=iso*'
	'-Wimplicit-function-declaration'
)

FLAG_FILTER_C_FORTRAN=(
	'-fabi-*'
	'-faligned-new'
	'-fcheck-new'
	'-fconcepts'
	'-fconstexpr-*'
	'-fdeduce-init-list'
	'-fext*'
	'-ffor-scope'
	'-ffriend-injection'
	'-fms-extensions'
	'-fnew-inheriting-ctors'
	'-fnew-ttp-matching'
	'-fno-access-control'
	'-fno-elide-constructors'
	'-fno-enforce-eh-specs'
	'-fno-extern-tls-init'
	'-fno-for-scope'
	'-fno-gnu-keywords'
	'-fno-implement-inlines'
	'-fno-implicit-*'
	'-fno-nonansi-builtins'
	'-fno-operator-names'
	'-fno-optional-diags'
	'-fno-pretty-templates'
	'-fno-rtti'
	'-fno-threadsafe-statics'
	'-fno-use-cxa-get-exception-ptr'
	'-fno-weak'
	'-fnothrow-opt'
	'-fpermissive'
	'-frepo'
	'-fsized-deallocation'
	'-fstrict-enums'
	'-fstrong-eval-order'
	'-ftemplate-*'
	'-fuse-cxa-atexit'
	'-fvisibility-*'
	'-nostdinc++'
	'-std=c++*'
	'-std=gnu++*'
	'-Wabi*'
	'-Wctor-dtor-privacy'
	'-Wdelete-non-virtual-dtor'
	'-Weffc++'
	'-Wliteral-suffix'
	'-Wlto-type-mismatch'
	'-Wmultiple-inheritance'
	'-Wnamespaces'
	'-Wno-narrowing'
	'-Wno-non-template-friend'
	'-Wno-pmf-conversions'
	'-Wno-terminate'
	'-Wnoexcept'
	'-Wnon-virtual-dtor'
	'-Wold-style-cast'
	'-Woverloaded-virtual'
	'-Wregister'
	'-Wreorder'
	'-Wsign-promo'
	'-Wstrict-null-sentinel'
	'-Wtemplates'
	'-Wvirtual-inheritance'
)

FLAG_FILTER_CFLAGS=(
)

FLAG_FILTER_CXXFLAGS=(
)

FLAG_FILTER_FORTRAN=(
	'-ansi'
	'-fallow-parameterless-variadic-functions'
	'-fcilkplus'
	'-fcond-mismatch'
	'-fdirectives-only'
	'-ffreestanding'
	'-fgimple'
	'-fgnu-tm'
	'-fgnu89-inline'
	'-fhosted'
	'-flax-vector-conversions'
	'-fms-extensions'
	'-fno-asm'
	'-fno-builtin*'
	'-fno-signed-bitfields'
	'-fno-unsigned-bitfields'
	'-fpermitted-flt-eval-methods*'
	'-fplan9-extensions'
	'-fsigned-*'
	'-fsso-struct*'
	'-funsigned-*'
	'-Wchkp'
	'-Wclobbered'
	'-Wformat*'
	'-Wvolatile-register-var'
)

FLAG_FILTER_FFLAGS=(
)

FLAG_FILTER_FCFLAGS=(
)

FLAG_FILTER_F77FLAGS=(
)

FLAG_FILTER_NONGNU=(
	'-fcf-protection*'
	'-fdevirtualize-at-ltrans'
	'-fdevirtualize-speculatively'
	'-fdirectives-only'
	'-fgcse*'
	'-fgraphite*'
	'-finline-functions'
	'-fipa-pta'
	'-fira-loop-pressure'
	'-fisolate-erroneous-paths-attribute'
	'-fivopts'
	'-flimit-function-alignment'
	'-floop*'
	'-flto=[0-9]*'
	'-flto=auto'
	'-flto=jobserver'
	'-flto-partition=*'
	'-flto-compression-level=*'
	'-fmodulo*'
	'-fno-enforce-eh-specs'
	'-fno-ident'
	'-fno-plt' # causes various runtime segfaults for clang:6 compiled code
	'-fno-semantic-interposition'
	'-fnothrow-opt'
	'-fpredictive-commoning'
	'-frename-registers'
	'-freorder-functions'
	'-frerun-cse-after-loop'
	'-fsched*'
	'-fsection-anchors'
	'-fstack-clash-protection'
	'-ftree*'
	'-funsafe-loop*'
	'-fuse-linker-plugin'
	'-fvect-cost-model'
	'-fweb'
	'-fwhole-program'
	'-malign-data*'
	'-mfunction-return*'
	'-mindirect-branch*'
	'-mvectorize*'
	'-Wl,-z,retpolineplt' # does not work, currently
)

FLAG_FILTER_GNU=(
	'-emit-llvm'
	'-flto=full'
	'-flto=thin'
	'-flto-jobs=*'
	'-fopenmp=*'
	'-frewrite-includes'
	'-fsanitize=cfi'
	'-fsanitize=safe-stack'
	'-mllvm'
	'-mretpoline*'
	'-polly*'
	'-Wl,-z,retpolineplt'
)

flag_eval() {
	case $- in
	*f*)
		eval "$*"
		;;
	*)
		set -f
		eval "$*"
		set +f
		;;
	esac
}

flag_no_dup_addr() {
	local addres addf addvar dups
	dups=$1
	shift
	addvar=$1
	shift
	eval addres=\$$addvar
	for addf; do
		case " $addres $dups " in
		*[[:space:]]"$addf"[[:space:]]*)
			continue ;;
		esac
		addres=$addres${addres:+\ }$addf
	done
	eval $addvar=\$addres
}

flag_add() {
	flag_no_dup_addr '' "$@"
}

flag_sub() {
	local subres subpat subf subvar sublist
	subvar=$1
	shift
	subres=
	eval sublist=\$$subvar
	for subf in $sublist; do
		for subpat; do
			[ -n "${subpat:++}" ] || continue
			case $subf in
			$subpat)
				subf=
				break
				;;
			esac
		done
		[ -z "${subf:++}" ] || subres=$subres${subres:+\ }$subf
	done
	eval $subvar=\$subres
}

flag_replace() {
	local repres repf repcurr repvar reppat
	repvar=$1
	shift
	eval repf=\$$repvar
	reppat=$1
	shift
	repres=
	for repcurr in $repf; do
		case $repcurr in
		$reppat)
			$repfound && flag_add repres "$@"
			continue
			;;
		esac
		repres=$repres${repres:+\ }$repcurr
	done
	eval $repvar=\$repres
}

flag_set() {
	local setvar
	setvar=$1
	shift
	eval $setvar=\$*
}

flag_add_cflags() {
	flag_add CFLAGS "$@"
	flag_add CXXFLAGS "$@"
}

flag_sub_cflags() {
	flag_sub CFLAGS "$@"
	flag_sub CXXFLAGS "$@"
	flag_sub CPPFLAGS "$@"
	flag_sub OPTCFLAGS "$@"
	flag_sub OPTCXXFLAGS "$@"
	flag_sub OPTCPPFLAGS "$@"
}

flag_replace_cflags() {
	flag_replace CFLAGS "$@"
	flag_replace CXXFLAGS "$@"
	flag_replace CPPFLAGS "$@"
	flag_sub OPTCFLAGS "$1"
	flag_sub OPTCXXFLAGS "$1"
	flag_sub OPTCPPFLAGS "$1"
}

flag_set_cflags() {
	flag_set CFLAGS "$@"
	CXXFLAGS=$CFLAGS
	CPPFLAGS=
	OPTCFLAGS=
	OPTCXXFLAGS=
	OPTCPPFLAGS=
}

flag_add_fflags() {
	flag_add FFLAGS "$@"
	flag_add FCFLAGS "$@"
	flag_add F77FLAGS "$@"
}

flag_sub_fflags() {
	flag_sub FFLAGS "$@"
	flag_sub FCFLAGS "$@"
	flag_sub F77FLAGS "$@"
}

flag_replace_fflags() {
	flag_replace FFLAGS "$@"
	flag_replace FCFLAGS "$@"
	flag_replace F77FLAGS "$@"
}

flag_set_fflags() {
	flag_set FFLAGS "$@"
	flag_set FCFLAGS "$@"
	flag_set F77FLAGS "$@"
}

flag_add_all_flags() {
	flag_add_cflags "$@"
	flag_add_fflags "$@"
}

flag_sub_all_flags() {
	flag_sub_cflags "$@"
	flag_sub_fflags "$@"
	flag_sub LDFLAGS "$@"
	flag_sub OPTLDFLAGS "$@"
}

flag_replace_all_flags() {
	flag_replace_cflags "$@"
	flag_replace_fflags "$@"
	flag_sub LDFLAGS "$1"
	flag_sub OPTLDFLAGS "$1"
}

flag_set_all_flags() {
	flag_set_cflags "$@"
	flag_set_fflags "$@"
	LDFLAGS=
	OPTLDFLAGS=
}

flag_athlon() {
	flag_sub_cflags '-march=*'
	flag_add_cflags '-march=athlon-4'
	command -v x86_64-pc-linux-gnu-gcc32 >/dev/null 2>&1 && \
		export CC=x86_64-pc-linux-gnu-gcc32
	command -v x86_64-pc-linux-gnu-g++32 >/dev/null 2>&1 && \
		export CXX=x86_64-pc-linux-gnu-g++32
}

flag_execute() {
	local ex exy excurr
	for excurr; do
		case $excurr in
		'#'*)
			return
			;;
		'!'*)
			[ "$HOSTTYPE" = 'i686' ] || continue
			ex=${excurr#?}
			;;
		'~'*)
			[ "$HOSTTYPE" = 'x86_64' ] || continue
			ex=${excurr#?}
			;;
		*)
			ex=$excurr
			;;
		esac
		case $ex in
		/*/*)
			ex=${ex%/}
			ex=${ex#/}
			flag_eval flag_replace_all_flags "${ex%%/*}" "${ex#*/}"
			;;
		'-'*)
			flag_add_cflags "$ex"
			;;
		'+flto*')
			flag_sub_all_flags '-flto*' '-fuse-linker-plugin' '-emit-llvm'
			;;
		'+'*)
			flag_sub_all_flags "-${ex#+}"
			;;
		'C*FLAGS-='*)
			flag_eval flag_sub_cflags ${ex#*-=}
			;;
		'C*FLAGS+='*)
			flag_eval flag_add_cflags ${ex#*+=}
			;;
		'C*FLAGS='*)
			flag_eval flag_set_cflags "${ex#*=}"
			;;
		'C*FLAGS/=/'*/*)
			ex=${ex%/}
			ex=${ex#*/=/}
			flag_eval flag_replace_cflags "${ex%%/*}" "${ex#*/}"
			;;
		'F*FLAGS-='*)
			flag_eval flag_sub_fflags ${ex#*-=}
			;;
		'F*FLAGS+='*)
			flag_eval flag_add_fflags ${ex#*+=}
			;;
		'F*FLAGS='*)
			flag_eval flag_set_fflags "${ex#*=}"
			;;
		'F*FLAGS/=/'*/*)
			ex=${ex%/}
			ex=${ex#*/=/}
			flag_eval flag_replace_fflags "${ex%%/*}" "${ex#*/}"
			;;
		'*FLAGS-='*)
			flag_eval flag_sub_all_flags ${ex#*-=}
			;;
		'*FLAGS+='*)
			flag_eval flag_add_all_flags ${ex#*+=}
			;;
		'*FLAGS='*)
			flag_eval flag_set_all_flags "${ex#*=}"
			;;
		'*FLAGS/=/'*/*)
			ex=${ex%/}
			ex=${ex#*/=/}
			flag_eval flag_replace_all_flags "${ex%%/*}" "${ex#*/}"
			;;
		'ATHLON32')
			flag_athlon
			;;
		'NOC*OPT='*|'NOC*='*)
			flag_eval flag_set NOCOPT "${ex#*=}"
			NOCXXOPT=$NOCOPT
			NOCPPOPT=$NOCOPT
			;;
		'NO*OPT='*)
			flag_eval flag_set NOCOPT "${ex#*=}"
			NOCXXOPT=$NOCOPT
			NOCPPOPT=$NOCOPT
			NOLDOPT=$NOCOPT
			;;
		'NOLD*='*)
			flag_eval flag_set NOLDOPT "${ex#*=}"
			NOLDADD=$NOLDOPT
			;;
		'NO*'*)
			flag_eval flag_set NOCOPT "${ex#*=}"
			NOCXXOPT=$NOCOPT
			NOCPPOPT=$NOCOPT
			NOLDOPT=$NOCOPT
			NOLDADD=$NOCOPT
			NOFFLAGS=$NOCOPT
			NOFCFLAGS=$NOCOPT
			NOF77FLAGS=$NOCOPT
			;;
		'SAFE')
			NOCOPT=1
			NOCXXOPT=1
			NOCPPOPT=1
			NOLDOPT=1
			MESONDEDUP=1
			LDFLAGS=
			CONFIG_SITE=
			NOLAFILEREMOVE=1
			unset CMAKE_MAKEFILE_GENERATOR
			;;
		*' '*'='*)
			flag_eval "$ex"
			;;
		*'/=/'*'/'*)
			ex=${ex%/}
			exy=${ex#*/=/}
			flag_eval flag_replace "${ex%%/=/*}" "${exy%%/*}" "${exy#*/}"
			;;
		*'-='*)
			flag_eval flag_sub "${ex%%-=*}" ${ex#*-=}
			;;
		*'+='*)
			flag_eval flag_add "${ex%%+=*}" ${ex#*+=}
			;;
		*'='*)
			flag_eval flag_set "${ex%%=*}" "${ex#*=}"
			;;
		*)
			flag_eval "$ex"
			;;
		esac
	done
}

flag_mask() {
	if command -v masked-packages >/dev/null 2>&1; then
		flag_mask() {
			masked-packages -qm "$1" -- "$CATEGORY/$PF:${SLOT:-0}${PORTAGE_REPO_NAME:+::}${PORTAGE_REPO_NAME-}"
		}
	else
		flag_mask() {
			local add=
			case ${1%::*} in
			*':'*)
				add=:${SLOT:-0};;
			esac
			case $1 in
			*'::'*)
				add=$add::$PORTAGE_REPO_NAME;;
			esac
			case $1 in
			'~'*)
				case "~$CATEGORY/$PN-$PV$add" in
				$1)
					return;;
				esac;;
			'='*)
				case "=$CATEGORY/$PF$add" in
				$1)
					return;;
				esac;;
			*)
				case "$CATEGORY/$PN$add" in
				$1)
					return;;
				esac;;
			esac
			return 1
		}
	fi
	flag_mask "$@"
}

flag_parse_line() {
	local scanp scanl scansaveifs
	scanl=$2
	while : ;do
		case $scanl in
		[[:space:]]*)
			scanl=${scanl#?}
			continue
			;;
		'#'*)
			return
			;;
		*[[:space:]]*)
			break
			;;
		esac
		return
	done
	scanp=${scanl%%[[:space:]]*}
	scanl=${scanl#*[[:space:]]}
	[ -n "${scanl:++}" ] || return 0
	flag_mask "$scanp" || return 0
	scansaveifs=$IFS
	IFS=$1
	bashrcd_echo "$scanfile -> $scanp: $scanl"
	flag_eval flag_execute $scanl
	IFS=$scansaveifs
}

flag_scan_file() {
	local scanfile scanl oldifs scanifs
	scanifs=$IFS
	IFS=
	for scanfile; do
		[ -z "${scanfile:++}" ] && continue
		test -r "$scanfile" || continue
		while read -r scanl; do
			flag_parse_line "$scanifs" "$scanl"
		done < "$scanfile"
	done
	IFS=$scanifs
}

flag_scan_dir() {
	local scantmp scanifs scanfile
	scanifs=$IFS
	if test -d "$1"; then
		IFS='
'
		for scantmp in `find -L "$1" \
		'(' '(' -name '.*' -o -name '*~' ')' -prune ')' -o \
			-type f -print`; do
			IFS=$scanifs
			flag_scan_file "$scantmp"
		done
	else
		flag_scan_file "$1"
	fi
	scanfile='FLAG_ADDLINES'
	IFS='
'
	for scantmp in $FLAG_ADDLINES; do
		flag_parse_line "$scanifs" "$scantmp"
	done
	IFS=$scanifs
}

flag_set_use_non_gnu() {
	case $CC$CXX in
	*clang*)
		return 0 ;;
	esac
	return 1
}

flag_set_non_gnu() {
	: ${NOLDADD:=1}
	flag_sub_all_flags "${FLAG_FILTER_NONGNU[@]}"
	flag_replace_all_flags '-fstack-check*' '-fstack-check'
	# flag_add_cflags '-flto' '-emit-llvm'
}

flag_set_gnu() {
	flag_sub_all_flags "${FLAG_FILTER_GNU[@]}"
}

flag_meson_dedup() {
	local newld=
	flag_no_dup_addr "$CFLAGS $CXXFLAGS $CPPFLAGS $FFLAGS $FCFLAGS $F77FLAGS" \
		newld $LDFLAGS
	LDFLAGS=$newld
}

flag_set_flags() {
	local ld i
	ld=
	: ${PGO_PARENT:=/var/cache/pgo}
	: ${PGO_DIR:=$PGO_PARENT/$CATEGORY:$P}
	flag_scan_dir "${PORTAGE_CONFIGROOT%/}/etc/portage/package.cflags"
	[ -z "${USE_NONGNU++}" ] && flag_set_use_non_gnu && USE_NONGNU=1
	if bashrcd_true "${USE_NONGNU-}"; then
		flag_set_non_gnu
	else	
		flag_set_gnu
	fi

	if [ -n "$FLAG_ADD" ]; then
		bashrcd_echo "FLAG_ADD: $FLAG_ADD"
		flag_eval flag_execute "$FLAG_ADD"
	fi

	PGO_DIR=${PGO_DIR%/}
	case ${PGO_DIR:-/} in
	/)
		error 'PGO_DIR must not be empty'
		false
		;;
	/*)
		:
		;;
	*)
		error 'PGO_DIR must be an absolute path'
		false
		;;
	esac || {
		die 'Bad PGO_DIR'
		exit 2
	}
	use_pgo=false
	if test -r "$PGO_DIR"; then
		unset PGO
		bashrcd_true $NOPGO || use_pgo=:
	fi
	if bashrcd_true $PGO; then
		flag_add_cflags "-fprofile-generate=$PGO_DIR" \
			-fvpt -fprofile-arcs
		flag_add LDFLAGS -fprofile-arcs
		addpredict "$PGO_PARENT"
	elif $use_pgo; then
		flag_add_cflags "-fprofile-use=$PGO_DIR" \
			-fvpt -fbranch-probabilities -fprofile-correction
	else
		: ${KEEPPGO:=:}
	fi
	bashrcd_true $NOLDOPT || flag_add LDFLAGS $OPTLDFLAGS
	bashrcd_true $NOCADD || bashrcd_true $MESONDEDUP || \
		case " $LDFLAGS $CFLAGS $CXXFLAGS" in
		*[[:space:]]'-flto'*)
			ld="$CFLAGS $CXXFLAGS" ;;
		esac
	bashrcd_true $NOLDADD || bashrcd_true $MESONDEDUP || flag_add_cflags $LDFLAGS
	flag_add LDFLAGS $ld
	bashrcd_true $NOCOPT || flag_add CFLAGS $OPTCFLAGS
	bashrcd_true $NOCXXOPT || flag_add CXXFLAGS $OPTCXXFLAGS
	bashrcd_true $NOCPPOPT || flag_add CPPFLAGS $OPTCPPFLAGS
	bashrcd_true $NOFFLAGS || FFLAGS=$CFLAGS
	bashrcd_true $NOFCFLAGS || FCFLAGS=$FFLAGS
	bashrcd_true $NOF77FLAGS || F77FLAGS=$FFLAGS
	bashrcd_true $NOFILTER_CXXFLAGS || flag_sub CXXFLAGS \
		"${FLAG_FILTER_C_CXX[@]}" "${FLAG_FILTER_CXX_FORTRAN[@]}" \
		"${FLAG_FILTER_CXXFLAGS[@]}"
	bashrcd_true $NOFILTER_CFLAGS || flag_sub CFLAGS \
		"${FLAG_FILTER_C_CXX[@]}" "${FLAG_FILTER_C_FORTRAN[@]}" \
		"${FLAG_FILTER_CFLAGS[@]}"
	bashrcd_true $NOFILTER_FFLAGS || flag_sub FFLAGS \
		"${FLAG_FILTER_C_FORTRAN[@]}" "${FLAG_FILTER_CXX_FORTRAN[@]}" \
		"${FLAG_FILTER_FORTRAN[@]}" "${FLAG_FILTER_FFLAGS[@]}"
	bashrcd_true $NOFILTER_FCFLAGS || flag_sub FCFLAGS \
		"${FLAG_FILTER_C_FORTRAN[@]}" "${FLAG_FILTER_CXX_FORTRAN[@]}" \
		"${FLAG_FILTER_FORTRAN[@]}" "${FLAG_FILTER_FCFLAGS[@]}"
	bashrcd_true $NOFILTER_F77FLAGS || flag_sub FCFLAGS \
		"${FLAG_FILTER_C_FORTRAN[@]}" "${FLAG_FILTER_CXX_FORTRAN[@]}" \
		"${FLAG_FILTER_FORTRAN[@]}" "${FLAG_FILTER_F77LAGS[@]}"
	! bashrcd_true $MESONDEDUP || flag_meson_dedup
	unset OPTCFLAGS OPTCXXFLAGS OPTCPPFLAGS OPTLDFLAGS
	unset NOLDOPT NOLDADD NOCOPT NOCXXOPT NOFFLAGS NOFCFLAGS NOF77FLAGS
	unset NOFILTER_CXXFLAGS NOFILTER_CFLAGS
	unset NOFILTER_FFLAGS NOFILTER_FCFLAGS NOFILTER_F77FLAGS
}

flag_info_export() {
	local out
	for out in FEATURES CFLAGS CXXFLAGS CPPFLAGS FFLAGS FCFLAGS F77FLAGS \
		LDFLAGS MAKEOPTS EXTRA_ECONF EXTRA_EMAKE USE_NONGNU; do
		eval "if [ -n \"\${$out:++}\" ]; then
			export $out
			bashrcd_echo \"$out='\$$out'\"
		else	
			unset $out
		fi"
	done
	if bashrcd_true $PGO; then
		bashrcd_echo "Create PGO into $PGO_DIR"
	elif $use_pgo; then
		bashrcd_echo "Using PGO from $PGO_DIR"
	fi
	out=`${CC:-gcc} --version | head -n 1` || out=
	bashrcd_echo "${out:-cannot determine gcc version}"
	out=`${CXX:-g++} --version | head -n 1` || out=
	bashrcd_echo "${out:-cannot determine g++ version}"
	out=`${LD:-ld} --version | head -n 1` || out=
	bashrcd_echo "${out:-cannot determine ld version}"
	bashrcd_echo "`uname -a`"
}

flag_compile() {
	eerror \
"${PORTAGE_CONFIGROOT%/}/etc/portage/bashrc.d/*flag.sh strange order of EBUILD_PHASE:"
	die "compile or preinst before setup"
	exit 2
}

flag_preinst() {
	flag_compile
}

flag_setup() {
	flag_compile() {
		:
	}

	local use_pgo
	flag_set_flags
	if bashrcd_true $PGO; then
		flag_preinst() {
			test -d "$PGO_DIR" || mkdir -p -m +1777 -- "$PGO_DIR" || {
				eerror "cannot create pgo directory $PGO_DIR"
				die 'cannot create PGO_DIR'
				exit 2
			}
			ewarn "$CATEGORY/$PN will write profile info to world-writable"
			ewarn "$PGO_DIR"
			ewarn 'Reemerge it soon for an optimized version and removal of that directory'
		}
	elif bashrcd_true $KEEPPGO; then
		flag_preinst() {
			:
		}
	else
		flag_preinst() {
			test -d "$PGO_DIR" || return 0
			bashrcd_log "removing pgo directory $PGO_DIR"
			rm -r -f -- "$PGO_DIR" || {
				eerror "cannot remove pgo directory $PGO_DIR"
				die 'cannot remove PGO_DIR'
				exit 2
			}
			local g
			g=${PGO_DIR%/*}
			[ -z "$g" ] || rmdir -p -- "$g" >/dev/null 2>&1
		}
	fi
	flag_info_export
}

bashrcd_phase compile flag_compile
bashrcd_phase preinst flag_preinst
bashrcd_phase setup flag_setup
