
class hubconfig {
	include hubconfig::packages
	include hubconfig::services
	include hubconfig::firewall
	include hubconfig::cms
	include hubconfig::misc	
}
