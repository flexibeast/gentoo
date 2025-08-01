# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
QTMIN=6.7.2
inherit cmake frameworks.kde.org python-any-r1

DESCRIPTION="Extra modules and scripts for CMake"
HOMEPAGE="https://invent.kde.org/frameworks/extra-cmake-modules"

LICENSE="BSD"
KEYWORDS="~amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv x86"
IUSE="doc test"

RESTRICT="!test? ( test )"

RDEPEND="app-arch/libarchive[bzip2]"
DEPEND="
	test? (
		>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
		>=dev-qt/qtdeclarative-${QTMIN}:6
	)
"
BDEPEND="
	doc? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]')
		>=dev-qt/qttools-${QTMIN}:6[assistant]
	)
	test? (
		>=dev-qt/qtbase-${QTMIN}:6
		>=dev-qt/qttools-${QTMIN}:6[linguist]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-5.49.0-no-fatal-warnings.patch"
	"${FILESDIR}/${PN}-5.93.0-skip-ecm_add_test-early.patch"
	"${FILESDIR}/${PN}-5.245.0-disable-qmlplugindump.patch"
	"${FILESDIR}/${PN}-6.5.0-disable-appstreamtest.patch"
	"${FILESDIR}/${PN}-6.5.0-disable-git-commit-hooks.patch"
)

python_check_deps() {
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DDOC_INSTALL_DIR=/usr/share/doc/"${PF}"
		-DBUILD_QTHELP_DOCS=$(usex doc)
		-DBUILD_HTML_DOCS=$(usex doc)
		-DBUILD_MAN_DOCS=$(usex doc)
		-DBUILD_TESTING=$(usex test)
	)
	if use test; then
		mycmakeargs+=( -DQT_MAJOR_VERSION=6 ) # bug 938316
	fi

	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# passes, but then breaks src_install
		ECMToolchainAndroidTest
		# broken, bug #627806
		ECMPoQmToolsTest
		# can not possibly succeed in releases, bug #764953
		KDEFetchTranslations
	)
	# possible race condition with multiple jobs, bug #701854
	cmake_src_test -j1
}
