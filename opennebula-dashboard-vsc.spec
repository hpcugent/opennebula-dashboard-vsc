##
# Copyright 2026 Ghent University
#
# This file is part of opennebula-dashboard-vsc,
# originally created by the HPC team of the University of Ghent (http://ugent.be/hpc).
#
#
# https://github.com/hpcugent/opennebula-dashboard-vsc
#
# opennebula-dashboard-vsc is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation v3.
#
# opennebula-dashboard-vsc is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with opennebula-dashboard-vsc. If not, see <http://www.gnu.org/licenses/>.
##

%define logospath /usr/share/opennebula-dashboard/logos
%define faviconpath /usr/share/opennebula-dashboard/favicon

Summary: VSC Opennebula Dashboard
Name: opennebula-dashboard-vsc
Version: 1.0
Release: 1.ug
License: GPLv3+
BuildArch: noarch
Requires: opennebula-fireedge
Source: %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot

%description
opennebula-dashboard-vsc provides logos and favicons for the VSC Cloud Opennebula dashboard.

%prep
%setup -q

%install
mkdir -p %{buildroot}%{logospath}
mkdir -p %{buildroot}%{faviconpath}

install -m 0644 vsc_full.png %{buildroot}%{logospath}/
install -m 0644 vsc_favicon.png %{buildroot}%{faviconpath}/

%files
%attr(0644, root, wheel) %{logospath}/*_full.png
%attr(0644, root, wheel) %{faviconpath}/*_favicon.png

%clean
rm -rf %{buildroot}

%changelog
* Thu Jun 11 2026 Jonathan De Loght <jonathan.deloght@UGent.be>
- Initial build.
