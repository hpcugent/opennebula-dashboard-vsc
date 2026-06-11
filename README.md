# opennebula-dashboard-vsc
This repo creates an RPM with branding for the VSC Cloud Dashboard.

## Usage
### Build RPM
Run `./buildrpmfromspec.sh`. The RPM should be in `~/rpmbuild/RPMS/noarch/` by default.

## Details
### `opennebula-dashboard-ugent.spec`
The RPM spec will place images in `files/` in the correct locations:
* `vsc_full.png` in `/usr/lib/one/fireedge/dist/client/assets/images/logos`
* `vsc_favicon.png` in `/usr/lib/one/fireedge/dist/client/assets/images/favicon`

### VSC Logos
You can find the VSC Userkit here: https://www.vscentrum.be/userkit
