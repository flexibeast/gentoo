# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for common completion tasks such as filename or URL completion"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	=kde-frameworks/kcodecs-${KDE_CATV}*:6
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/kwidgetsaddons-${KDE_CATV}*:6
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"
