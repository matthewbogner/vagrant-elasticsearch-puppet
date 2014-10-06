# TODO: Classifying the nodes allows future provision for the full ELK stack to be provisioned. This should at some point be part of the Vagrant setup
node 'default' {
	class {'elasticsearch': 
		seeds => "$seeds",
	}
}
