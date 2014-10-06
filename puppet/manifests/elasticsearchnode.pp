node 'esnode1' {
	class {'elasticsearch': }
}

node 'esnode2' {
        class {'elasticsearch': }
}

node 'default' {
	notice "Host not found"
}
