class elasticsearch($seeds = "") {
	$es_version = "1.3"
	# As good practice just incase there are any exec statements or cache directories required
	Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
	$tmpDir = "/tmp/elasticsearch"
	
	file { "$tmpDir":
	  ensure => directory,
	}

	# Set up yum repo for elastic search as this is now supported
	file { "/etc/yum.repos.d/elasticsearch.repo":
	  content => template('elasticsearch/elasticsearch.repo.erb'),
	}

	# Note that elasticsearch 1.3 onwards only supports Java 7
	# Verify that update-alternatives is used just in case there is a version mismatch
	# Tested against a base box with no issues

	package { ["java-1.7.0-openjdk","elasticsearch"]: 
	  ensure => present,
	  require => File["/etc/yum.repos.d/elasticsearch.repo"],
	}
	
	file { "/etc/elasticsearch/elasticsearch.yml":
	  content => template('elasticsearch/elasticsearch.yml.erb'),
	  require => Package['elasticsearch'],
	}
	
	file { '/etc/security/limits.d/80-nofile.conf':
	  content => template('elasticsearch/80-nofile.conf'),
	  require => Package['elasticsearch'],
	}
	
		service { 'elasticsearch':
	  ensure => running,
	  subscribe  => File['/etc/elasticsearch/elasticsearch.yml'],
	  require => Package['elasticsearch'],
	}

	service { 'iptables': 
	  ensure => stopped,      #HACK!  use the puppet firewall module to manage iptables 
	  require => Service['elasticsearch'],
	}

}