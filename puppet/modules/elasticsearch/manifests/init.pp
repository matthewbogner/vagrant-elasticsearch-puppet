class elasticsearch($version = "0.19.10", $seeds = "") {

	Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

	$tmpDir = "/tmp/elasticsearch"

	package { 'java-1.6.0-openjdk': 
	  ensure => present,
	}
	->
	package { 'unzip':
	  ensure => present,
	}
	->
	file { "$tmpDir":
	  ensure => directory,
	}
	->
	exec { 'es-download-tarball':
      command => "wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$version.tar.gz -O elasticsearch.tar.gz",
      cwd => "$tmpDir",
      creates => "$tmpDir/elasticsearch.tar.gz"
    }
    ->
    exec { 'es-untar':
      command => 'tar -xf elasticsearch.tar.gz',
      cwd => "$tmpDir",
      creates => "$tmpDir/elasticsearch-$version"
    }
    ->
    exec { 'es-move-binaries':
      command => "cp -rp elasticsearch-$version /usr/local/share",
      cwd => "$tmpDir",
      creates => "/usr/local/share/elasticsearch-$version",
    }
    ->
    exec { 'es-download-servicewrapper': 
      command => 'curl -L http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master | tar -xz',
      cwd => "$tmpDir",
      unless => "ls | grep servicewrapper",
    }
    ->
	exec { 'es-move-servicewrapper':
	  command => "cp -rp *servicewrapper*/service /usr/local/share/elasticsearch-$version/bin/",
	  cwd => "$tmpDir",
	  creates => "/usr/local/share/elasticsearch-$version/bin/service",
	}
	->
	exec { 'es-install-servicewrapper': 
	  command => "/usr/local/share/elasticsearch-$version/bin/service/elasticsearch install && touch /usr/local/share/elasticsearch-$version/bin/service/service.installed",
	  creates => "/usr/local/share/elasticsearch-$version/bin/service/service.installed",
	}
	->
	file { "/usr/local/share/elasticsearch-$version/config/elasticsearch.yml":
	  content => template('elasticsearch/elasticsearch.yml.erb'),
	}
	->
	exec { 'es-install-head-plugin': 
	  command => "/usr/local/share/elasticsearch-$version/bin/plugin -install mobz/elasticsearch-head",
	  creates => "/usr/local/share/elasticsearch-$version/plugins/head",
	}
	->
	service { 'elasticsearch':
	  ensure => running,
	}
	->
	service { 'iptables': 
	  ensure => stopped,      #HACK!  use the puppet firewall module to manage iptables 
	}

}